#!/bin/bash

if [[ ! -d "$HOME/.ssh" ]]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
fi

DOT_DIR="${HOME}/dotfiles"

allowed_dirs_or_files=(".config" "Library" "zsh" ".zshrc")

if cd "$DOT_DIR"; then
  for f in $(find . -not -path '*.git*' -not -path '*.DS_Store' -type f -print | cut -b3-)
  do
    for dir in "${allowed_dirs_or_files[@]}"; do
      echo $f
      echo $dir
      if [[ "$f" == $dir/* || "$f" == "$dir" ]]; then
        mkdir -p "$HOME/$(dirname "$f")"

        if [ -L "$HOME/$f" ]; then
          ln -sfv "$DOT_DIR/$f" "$HOME/$f"
        else
          ln -sniv "$DOT_DIR/$f" "$HOME/$f"
        fi

        break
      fi
    done
  done
else
  echo "cannot cd to $DOT_DIR"
fi
