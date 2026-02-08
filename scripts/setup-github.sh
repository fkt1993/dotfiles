#!/bin/bash
set -e

# --- SSH鍵の生成とGitHub登録 ---
SSH_KEY="$HOME/.ssh/id_ed25519_github"
if [ ! -f "$SSH_KEY" ]; then
  echo "SSH鍵を生成します..."
  mkdir -p "$HOME/.ssh"
  ssh-keygen -t ed25519 -f "$SSH_KEY" -N ""
fi

# ~/.ssh/config にGitHub用の設定を追加
SSH_CONFIG="$HOME/.ssh/config"
if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
  echo "SSH configにGitHub設定を追加します..."
  cat >> "$SSH_CONFIG" <<EOF

Host github.com
  IdentityFile $SSH_KEY
  AddKeysToAgent yes
EOF
  chmod 600 "$SSH_CONFIG"
fi

# GitHubにSSH鍵を登録
echo "GitHub CLIでログインします..."
gh auth login -s admin:public_key
gh ssh-key add "${SSH_KEY}.pub" --title "$(scutil --get ComputerName)"

# admin:public_key スコープを除去
echo "不要になった権限を除去します..."
gh auth refresh -h github.com --reset-scopes

# dotfilesのremoteをSSHに切り替え
DOTFILES_DIR="$HOME/dotfiles"
git -C "$DOTFILES_DIR" remote set-url origin git@github.com:fkt1993/dotfiles.git

echo "GitHub SSHの設定が完了しました"
