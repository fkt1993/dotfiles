#!/bin/bash -eu

echo "Start setup ..."

if [ $(uname) = Darwin ]; then
  if ! type brew &> /dev/null ; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
      echo "Since Homebrew is already installed, skip this phase and proceed."
  fi
  brew bundle --file=Brewfile

  if [ -z "${DOTFILES_PROFILE:-}" ]; then
    echo ""
    echo "Select profile:"
    echo "  1) personal"
    echo "  2) work"
    echo "  3) skip (common packages only)"
    read -r -p "Enter choice [1-3]: " choice
    case "$choice" in
      1) DOTFILES_PROFILE="personal" ;;
      2) DOTFILES_PROFILE="work" ;;
      *) DOTFILES_PROFILE="" ;;
    esac
  fi

  if [ -n "${DOTFILES_PROFILE:-}" ]; then
    PROFILE_BREWFILE="Brewfile.${DOTFILES_PROFILE}"
    if [ -f "$PROFILE_BREWFILE" ]; then
      brew bundle --file="$PROFILE_BREWFILE"
    else
      echo "Warning: $PROFILE_BREWFILE not found, skipping."
    fi
  fi
fi
