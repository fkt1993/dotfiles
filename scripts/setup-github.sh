#!/bin/bash
set -e

# --- SSH鍵の生成とGitHub登録 ---
SSH_KEY="$HOME/.ssh/id_ed25519_github"
if [ ! -f "$SSH_KEY" ]; then
  echo "SSH鍵を生成します..."
  mkdir -p "$HOME/.ssh"
  ssh-keygen -t ed25519 -f "$SSH_KEY" -N ""
fi

# GitHubにSSH鍵を登録
echo "GitHub CLIでログインします..."
gh auth login
gh ssh-key add "${SSH_KEY}.pub" --title "$(scutil --get ComputerName)"

# dotfilesのremoteをSSHに切り替え
DOTFILES_DIR="$HOME/dotfiles"
git -C "$DOTFILES_DIR" remote set-url origin git@github.com:fkt1993/dotfiles.git

echo "GitHub SSHの設定が完了しました"
