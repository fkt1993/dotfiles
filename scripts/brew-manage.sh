#!/bin/bash
set -eu

source "$(dirname "$0")/lib-profile.sh"
BREWFILE_COMMON="$DOTFILES_DIR/Brewfile"
BREWFILE_PERSONAL="$DOTFILES_DIR/Brewfile.personal"
BREWFILE_WORK="$DOTFILES_DIR/Brewfile.work"

ALL_BREWFILES=("$BREWFILE_COMMON" "$BREWFILE_PERSONAL" "$BREWFILE_WORK")

# Extract package lines (brew/cask/tap/mas) from a Brewfile
parse_packages() {
  local file="$1"
  if [ -f "$file" ]; then
    grep -E '^(brew|cask|tap|mas) ' "$file" 2>/dev/null || true
  fi
}

# Get all registered packages across all Brewfiles
all_registered() {
  for f in "${ALL_BREWFILES[@]}"; do
    parse_packages "$f"
  done | sort -u
}

# Get currently installed packages in Brewfile format
installed_packages() {
  brew bundle dump --file=- 2>/dev/null | grep -v '^vscode '
}

# --- dump subcommand ---
cmd_dump() {
  local profile="${1:-}"
  if [ -z "$profile" ]; then
    profile="$(resolve_profile)"
  fi
  if [ -z "$profile" ]; then
    echo "No profile selected."
    exit 1
  fi
  if [ "$profile" != "personal" ] && [ "$profile" != "work" ]; then
    echo "Error: profile must be 'personal' or 'work'"
    exit 1
  fi

  local target="$DOTFILES_DIR/Brewfile.$profile"

  echo "Scanning installed packages..."
  local installed
  installed="$(installed_packages)"

  local registered
  registered="$(all_registered)"

  local new_packages
  new_packages="$(comm -23 <(echo "$installed" | sort) <(echo "$registered" | sort))"

  if [ -z "$new_packages" ]; then
    echo "No untracked packages found. Everything is already registered."
    exit 0
  fi

  local count
  count="$(echo "$new_packages" | wc -l | tr -d ' ')"

  echo "$new_packages" >> "$target"
  echo "Added $count packages to Brewfile.$profile:"
  echo "$new_packages" | sed 's/^/  /'
}

# --- sync subcommand ---
cmd_sync() {
  if [ ! -f "$BREWFILE_PERSONAL" ] || [ ! -f "$BREWFILE_WORK" ]; then
    echo "Error: Both Brewfile.personal and Brewfile.work must exist."
    exit 1
  fi

  local personal_pkgs
  personal_pkgs="$(parse_packages "$BREWFILE_PERSONAL" | sort)"

  local work_pkgs
  work_pkgs="$(parse_packages "$BREWFILE_WORK" | sort)"

  if [ -z "$personal_pkgs" ] || [ -z "$work_pkgs" ]; then
    echo "No common packages found (one or both profile Brewfiles are empty)."
    exit 0
  fi

  local common
  common="$(comm -12 <(echo "$personal_pkgs") <(echo "$work_pkgs"))"

  if [ -z "$common" ]; then
    echo "No common packages found between personal and work."
    exit 0
  fi

  # Filter out packages already in common Brewfile
  local existing_common
  existing_common="$(parse_packages "$BREWFILE_COMMON" | sort)"

  local to_add
  to_add="$(comm -23 <(echo "$common" | sort) <(echo "$existing_common"))"

  # Add new common packages to Brewfile
  if [ -n "$to_add" ]; then
    echo "$to_add" >> "$BREWFILE_COMMON"
  fi

  # Remove common packages from personal and work
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    # Escape for sed: handle special characters in package lines
    local escaped
    escaped="$(echo "$pkg" | sed 's/[.[\/*^$]/\\&/g')"
    sed -i '' "/^${escaped}$/d" "$BREWFILE_PERSONAL"
    sed -i '' "/^${escaped}$/d" "$BREWFILE_WORK"
  done <<< "$common"

  # Clean up empty lines left behind
  for f in "$BREWFILE_PERSONAL" "$BREWFILE_WORK"; do
    # Remove trailing empty lines
    sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$f" 2>/dev/null || true
  done

  local count
  count="$(echo "$common" | wc -l | tr -d ' ')"
  echo "Moved $count common packages to Brewfile:"
  echo "$common" | sed 's/^/  /'
}

# --- status subcommand ---
cmd_status() {
  local count
  for f in "${ALL_BREWFILES[@]}"; do
    local name
    name="$(basename "$f")"
    if [ -f "$f" ]; then
      count="$(parse_packages "$f" | wc -l | tr -d ' ')"
    else
      count="(not found)"
    fi
    printf "%-20s %s packages\n" "$name:" "$count"
  done

  echo ""

  local installed
  installed="$(installed_packages | sort)"

  local registered
  registered="$(all_registered)"

  local untracked
  untracked="$(comm -23 <(echo "$installed") <(echo "$registered" | sort))"

  if [ -z "$untracked" ]; then
    echo "Untracked:           0 packages"
  else
    count="$(echo "$untracked" | wc -l | tr -d ' ')"
    echo "Untracked:           $count packages"
    echo "$untracked" | sed 's/^/  /'
  fi
}

# --- main ---
if [ "$(uname)" != "Darwin" ]; then
  echo "Error: This script only runs on macOS."
  exit 1
fi

case "${1:-}" in
  dump)
    shift
    cmd_dump "$@"
    ;;
  sync)
    cmd_sync
    ;;
  status)
    cmd_status
    ;;
  *)
    echo "Usage: brew-manage.sh <command>"
    echo ""
    echo "Commands:"
    echo "  dump <personal|work>  Add untracked packages to a profile Brewfile"
    echo "  sync                  Move common packages to Brewfile"
    echo "  status                Show package counts and untracked packages"
    ;;
esac
