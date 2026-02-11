#!/bin/bash -eu

if [[ ! -d "$HOME/.ssh" ]]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
fi

DOT_DIR="${HOME}/dotfiles"
allowed_dirs=(
  "${DOT_DIR}/.config"
  "${DOT_DIR}/Library"
  "${DOT_DIR}/zsh"
  "${DOT_DIR}/.zshrc"
)

if cd "$DOT_DIR"; then
  # .workflow バンドルはディレクトリごとシンボリックリンク（個別ファイルだとAutomatorが読めない）
  find "${allowed_dirs[@]}" -name '*.workflow' -type d -print | while read -r f; do
    rel_path="${f#${DOT_DIR}/}"
    target="$HOME/$rel_path"

    mkdir -p "$(dirname "$target")"

    ln -sfv "$f" "$target"
  done

  # 通常ファイルは個別にシンボリックリンク（.workflow内は除外）
  find "${allowed_dirs[@]}" -not -path '*.git*' -not -path '*.DS_Store' -not -path '*.workflow/*' -type f -print | while read -r f; do
    rel_path="${f#${DOT_DIR}/}"
    target="$HOME/$rel_path"

    mkdir -p "$(dirname "$target")"

    ln -sfv "$f" "$target"
  done
else
  echo "Cannot access $DOT_DIR"
fi
