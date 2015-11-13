#!/bin/sh


# Dock & Finder Defaults

defaults_dock_finder() {

  echo -b 'Setting Defaults for Dock & Finder …'

  # Desktop and Finder

  # Show “Library” folder.
  chflags nohidden ~/Library

  # Show Drives and Servers on Desktop
  defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool true
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop     -bool true

  # Desktop View Settings
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.finder.plist \
    -c 'Set :DesktopViewSettings:IconViewSettings:arrangeBy            name' \
    -c 'Set :DesktopViewSettings:IconViewSettings:backgroundColorBlue  1' \
    -c 'Set :DesktopViewSettings:IconViewSettings:backgroundColorGreen 1' \
    -c 'Set :DesktopViewSettings:IconViewSettings:backgroundColorRed   1' \
    -c 'Set :DesktopViewSettings:IconViewSettings:backgroundType       0' \
    -c 'Set :DesktopViewSettings:IconViewSettings:gridOffsetX          0' \
    -c 'Set :DesktopViewSettings:IconViewSettings:gridOffsetY          0' \
    -c 'Set :DesktopViewSettings:IconViewSettings:gridSpacing          100' \
    -c 'Set :DesktopViewSettings:IconViewSettings:iconSize             64' \
    -c 'Set :DesktopViewSettings:IconViewSettings:labelOnBottom        false' \
    -c 'Set :DesktopViewSettings:IconViewSettings:showIconPreview      true' \
    -c 'Set :DesktopViewSettings:IconViewSettings:showItemInfo         true' \
    -c 'Set :DesktopViewSettings:IconViewSettings:textSize             12' \
    -c 'Set :DesktopViewSettings:IconViewSettings:viewOptionsVersion   1' \
  ; killall cfprefsd &>/dev/null

  # Expand all fields in Info Viewer
  defaults write com.apple.finder FXInfoPanesExpanded -dict-add Comments   -bool true
  defaults write com.apple.finder FXInfoPanesExpanded -dict-add MetaData   -bool true
  defaults write com.apple.finder FXInfoPanesExpanded -dict-add Name       -bool true
  defaults write com.apple.finder FXInfoPanesExpanded -dict-add OpenWith   -bool true
  defaults write com.apple.finder FXInfoPanesExpanded -dict-add Privileges -bool true

  # Show Finder Sidebar
  defaults write com.apple.finder ShowSidebar       -bool true
  defaults write com.apple.finder ShowStatusBar     -bool true
  defaults write com.apple.finder ShowPreviewPane   -bool true

  # Show Drives and Servers in Sidebar
  defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks  -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable  -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowServers    -bool true

  # Show Network Devices in Sidebar
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist \
    -c 'Set :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.backToMyMacEnabled true' \
    -c 'Set :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.bonjourEnabled     true' \
    -c 'Set :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.connectedEnabled   true' \
  ; killall cfprefsd &>/dev/null

  # Disable Warning when changing a Extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Disable Warning when emptying Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  # Search Current Folder by Defaults
  defaults write com.apple.finder FXDefaultSearchScope 'SCcf'

  # Use column view in all Finder windows by default.
  defaults write com.apple.finder FXPreferredViewStyle -string 'clmv'

  # Open new Finder windows with User folder.
  defaults write com.apple.finder NewWindowTarget -string 'PfHm'

  # Disable the “Are you sure you want to open this application?” Dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Enable spring-loading directories and decrease default delay.
  defaults write NSGlobalDomain com.apple.springing.enabled -bool  true
  defaults write NSGlobalDomain com.apple.springing.delay   -float 0.2

  # Disable Disk Image Verification
  defaults write com.apple.frameworks.diskimages skip-verify        -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true


  # Dock, Dashboard & Mission Control

  # Disable Dashboard
  defaults write com.apple.dashboard enabled-state -int 1

  # Increase Mission Control Animation Speed
  defaults write com.apple.dock expose-animation-duration -float 0.125
  defaults write com.apple.dock expose-group-apps         -bool true

  # Automatically hide Dock
  defaults write com.apple.dock autohide -bool true

  # Translucent Icons of hidden Applications
  defaults write com.apple.dock showhidden -bool true

  killall cfprefsd &>/dev/null
  killall Dock &>/dev/null

}
