#!/usr/bin/env bash
# macOS preferences for development. Run it yourself: ./macos.sh
# Every line is a plain `defaults write`; read them before running. Some need a logout to apply.
set -euo pipefail

echo "==> Keyboard: fast key repeat, no autocorrect in code fields"
defaults write -g KeyRepeat -int 2                 # fastest the UI allows is 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false   # hold a key = repeat (accented letters have their own keys on the HU layout)
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

echo "==> Finder: extensions, hidden files, path bar, list view, folders first"
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string SCcf       # search the current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder NewWindowTarget -string PfLo
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/Developer/"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "==> Dock: auto-hide without delay, no recent apps, keep Spaces in order"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.25
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false

echo "==> Screenshots: ~/Pictures/Screenshots, PNG, no window shadow"
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string png
defaults write com.apple.screencapture disable-shadow -bool true

echo "==> Dialogs: expanded save and print panels"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true

killall Finder Dock SystemUIServer 2>/dev/null || true
echo "Done. Key repeat changes apply after you log out and back in."
