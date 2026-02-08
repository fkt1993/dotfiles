# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal macOS dotfiles repository for managing system configurations, shell customization, and application settings. Configuration files are symlinked from this repository to the home directory for version control.

## Setup Commands

```bash
# Full installation (installs Homebrew, packages, creates symlinks, applies macOS defaults)
./install.sh

# Individual setup scripts
./scripts/setup-brew.sh    # Install Homebrew packages from Brewfile
./scripts/setup-links.sh   # Create symlinks to home directory
./scripts/setup-mac.sh     # Apply macOS system preferences
```

## Architecture

### Symlink Structure
The `setup-links.sh` script creates symlinks for:
- `.config/` → `~/.config/` (git config, karabiner)
- `Library/` → `~/Library/` (Spectacle, Services)
- `zsh/` → `~/zsh/` (shell modules)
- `.zshrc` → `~/.zshrc`

### Shell Configuration
- `.zshrc` - Main entry point, sets up PATH, nodenv, and sources zsh modules
- `zsh/.zshrc.alias` - Ruby/Rails development aliases (rubo, mig, roll, side)
- `zsh/.zshrc.fzf` - fzf-powered functions (sshsp, fsh with Ctrl+R binding)

### Key Configuration Files
- `.config/git/config` - Extensive Git aliases using fzf for interactive selection
- `.config/karabiner/karabiner.json` - Emacs keybindings with app-specific exceptions
- `Brewfile` - Homebrew packages (peco, sequel-ace, xcodes)

## Conventions

- All setup scripts check for Darwin/macOS before running platform-specific commands
- Brewfile uses `brew bundle` for reproducible package installation
- Git aliases heavily integrate with fzf for interactive workflows
