#!/bin/bash -eu

source "$(dirname "$0")/lib-profile.sh"

echo "Start setup ..."

if [ $(uname) = Darwin ]; then
  if ! type brew &> /dev/null ; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
      echo "Since Homebrew is already installed, skip this phase and proceed."
  fi
  brew bundle --file=Brewfile

  DOTFILES_PROFILE="$(resolve_profile)"
  if [ -n "$DOTFILES_PROFILE" ]; then
    PROFILE_BREWFILE="Brewfile.${DOTFILES_PROFILE}"
    if [ -f "$PROFILE_BREWFILE" ]; then
      brew bundle --file="$PROFILE_BREWFILE"
    else
      echo "Warning: $PROFILE_BREWFILE not found, skipping."
    fi
  fi
fi
