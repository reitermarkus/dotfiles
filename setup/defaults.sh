# Login Window

cecho 'Disabling Guest Account …' $blue
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false


# Finder Appearance and Behaviour

cecho 'Showing Icons for Hard Drives, Servers, and Removable Media on the Desktop …' $blue
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

cecho 'Showing Finder Sidebar …' $blue
defaults write com.apple.finder ShowSidebar -bool true


if [ -f ~/Library/Preferences/com.apple.sidebarlists.plist ]; then

  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist -c "set networkbrowser:CustomListProperties:com.apple.NetworkBrowser.backToMyMacEnabled 1"
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist -c "set networkbrowser:CustomListProperties:com.apple.NetworkBrowser.bonjourEnabled 1"
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist -c "set networkbrowser:CustomListProperties:com.apple.NetworkBrowser.connectedEnabled 1"

  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist -c "set systemitems:ShowEjectables 1"
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist -c "set systemitems:ShowHardDisks 1"
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist -c "set systemitems:ShowRemovable 1"
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist -c "set systemitems:ShowServers 1"

fi


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
