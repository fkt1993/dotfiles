#!/usr/bin/env bash
set -x

# Menubar
defaults write com.apple.menuextra.battery ShowPercent -bool true
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"

# キーリピートの高速化
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# スペルの訂正を無効にする
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# マウスの速度を速める
defaults write -g com.apple.mouse.scaling 5
