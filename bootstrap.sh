#!/bin/bash
set -e

# curl | bash で実行された場合、stdinをターミナルに復元（Homebrewのsudoプロンプトに必要）
if [ ! -t 0 ]; then
  exec < /dev/tty
fi

# Xcode Command Line Toolsのインストール(gitに必要)
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "Xcode Command Line Toolsのインストールを待機中..."
  echo "インストール完了後、このスクリプトを再実行してください。"
  exit 0
fi

# dotfilesのクローン
DOTFILES_DIR="$HOME/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  echo "Error: $DOTFILES_DIR は既に存在します"
  exit 1
fi

git clone https://github.com/fkt1993/dotfiles.git "$DOTFILES_DIR"
cd "$DOTFILES_DIR"
./install.sh
./scripts/setup-github.sh

echo "セットアップが完了しました"
