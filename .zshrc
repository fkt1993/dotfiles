#!/usr/bin/env zsh

export DOTFILES_HOME=~/dotfiles
export DOTFILES_ZSH_HOME=${DOTFILES_HOME}/zsh

PATH="${DOTFILES_HOME}/bin:${PATH}"

eval "$(nodenv init -)"

# direnv
# eval "$(direnv hook zsh)"

# alias
# shellcheck source=.zshrc.alias
source ${DOTFILES_ZSH_HOME}/.zshrc.alias

# fzf
# shellcheck source=.zshrc.fzf
source ${DOTFILES_ZSH_HOME}/.zshrc.fzf

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  autoload -Uz compinit && compinit
fi

if [ -e ~/.zsh/completions ]; then
  fpath=(~/.zsh/completions $fpath)
fi

autoload -U compinit
compinit

source ~/.zshrc.local
