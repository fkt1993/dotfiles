#!/bin/bash
# Shared profile resolution for dotfiles scripts
# Usage: source "$(dirname "$0")/lib-profile.sh"

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DOTFILES_ENV="$DOTFILES_DIR/.env"

# Resolve profile: .env file > fzf selection > fallback prompt
# Returns the profile name (personal/work) or empty string
resolve_profile() {
  # 1. Check .env file
  if [ -f "$DOTFILES_ENV" ]; then
    local saved
    saved="$(grep '^DOTFILES_PROFILE=' "$DOTFILES_ENV" 2>/dev/null | cut -d= -f2)" || true
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

  # 3. Save selection to .env
  if [ "$profile" = "personal" ] || [ "$profile" = "work" ]; then
    if [ -f "$DOTFILES_ENV" ]; then
      # Update existing DOTFILES_PROFILE or append
      if grep -q '^DOTFILES_PROFILE=' "$DOTFILES_ENV" 2>/dev/null; then
        sed -i '' "s/^DOTFILES_PROFILE=.*/DOTFILES_PROFILE=$profile/" "$DOTFILES_ENV"
      else
        echo "DOTFILES_PROFILE=$profile" >> "$DOTFILES_ENV"
      fi
    else
      echo "DOTFILES_PROFILE=$profile" > "$DOTFILES_ENV"
    fi
    echo "Profile saved to $DOTFILES_ENV" >&2
    echo "$profile"
  fi
}
