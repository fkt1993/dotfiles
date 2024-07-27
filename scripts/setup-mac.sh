#!/usr/bin/env bash
set -x

# マウスの速度を速める
defaults write -g com.apple.mouse.scaling 1.5
# トラックパッドの速度を速める
defaults write -g com.apple.trackpad.scaling 1.5

# [システム環境設定 > キーボード > 入力ソース > "¥"キーで入力する文字] = "\ (バックスラッシュ)"
defaults write -g com.apple.inputmethod.Kotoeri 'JIMPrefCharacterForYenKey' -int 1

# キーの長押し時に、特殊文字ポップアップを無効にする
defaults write -g ApplePressAndHoldEnabled -bool false

# 未確認
# キーリピートの高速化
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# スペルの訂正を無効にする
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# 以下うまく効いていない
# Menubar
defaults write -g com.apple.menuextra.battery ShowPercent -string "YES"
defaults write -g com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"

# ライブ変換をオフ
defaults write -g JIMPrefLiveConversionKey -bool false

# 手動で設定
# - NightShiftの設定
