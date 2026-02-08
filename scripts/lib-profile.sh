#!/bin/bash
# Shared profile resolution for dotfiles scripts
# Usage: source "$(dirname "$0")/lib-profile.sh"

DOTFILES_PROFILE_FILE="$HOME/.dotfiles_profile"

# Resolve profile: saved file > fzf selection > fallback prompt
# Returns the profile name (personal/work) or empty string
resolve_profile() {
  # 1. Check saved profile
  if [ -f "$DOTFILES_PROFILE_FILE" ]; then
    local saved
    saved="$(cat "$DOTFILES_PROFILE_FILE")"
    if [ "$saved" = "personal" ] || [ "$saved" = "work" ]; then
      echo "$saved"
      return
    fi
  fi

  # 2. Interactive selection
  local profile=""
  if type fzf &>/dev/null; then
    profile="$(printf 'personal\nwork\nskip' | fzf --prompt='Select profile> ' --height=5 --reverse)" || true
  else
    echo "Select profile:" >&2
    echo "  1) personal" >&2
    echo "  2) work" >&2
    echo "  3) skip" >&2
    read -r -p "Enter choice [1-3]: " choice
    case "$choice" in
      1) profile="personal" ;;
      2) profile="work" ;;
      *) profile="skip" ;;
    esac
  fi

  # 3. Save selection
  if [ "$profile" = "personal" ] || [ "$profile" = "work" ]; then
    echo "$profile" > "$DOTFILES_PROFILE_FILE"
    echo "Profile saved to $DOTFILES_PROFILE_FILE" >&2
    echo "$profile"
  fi
}
