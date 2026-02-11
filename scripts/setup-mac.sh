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

## Menubar
defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool "true"

## docs
# 自動的に非表示
defaults write com.apple.dock "autohide" -bool "true"
# 画面上の位置を左
defaults write com.apple.dock "orientation" -string "left"
# サイズ
defaults write com.apple.dock "tilesize" -int "48"
# 拡大
defaults write com.apple.dock "largesize" -int "1"

## Finder
defaults write com.apple.finder "ShowPathbar" -bool "true"

# 未確認
# キーリピートの高速化
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# スペルの訂正を無効にする
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# ライブ変換をオフ
defaults write -g JIMPrefLiveConversionKey -bool false

## Night Shift
# 5:00〜4:59 のカスタムスケジュールで常時有効化
nightlight schedule 5:00 4:59
# 色温度を最大暖色に設定
nightlight temp 100
# 「明日まで有効にする」をオンにする
nightlight on

# 手動で設定
# - Finderのサイドバー
