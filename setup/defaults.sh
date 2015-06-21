# Login Window

cecho 'Disabling Guest Account …' $blue
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false


# Finder Appearance and Behaviour

cecho 'Showing Icons for Hard Drives, Servers, and Removable Media on the Desktop …' $blue
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

cecho 'Disabling the Warning when changing a Extension …' $blue
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

cecho 'Disabling the Warning when emptying Trash …' $blue
defaults write com.apple.finder WarnOnEmptyTrash -bool false


# Dock & Mission Control

cecho 'Increasing Mission Control Animation Speed …' $blue
defaults write com.apple.dock expose-animation-duration -float 0.125

cecho 'Hiding Dock automatically …' $blue
defaults write com.apple.dock autohide -bool true


# Safari

cecho "Changing Safari's In-Page Search to “contains” instead of “starts with” …" $blue
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false


# General User Interface

cecho 'Expanding the Save Panel by Default …' $blue
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint    -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2   -bool true

cecho 'Removing Duplicates in “Open With” Menu …' $blue
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user &
