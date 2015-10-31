#!/bin/sh


# Dock & Finder Defaults

defaults_dock_finder() {

  # Desktop and Finder

  # Show “Library” folder.
  chflags nohidden ~/Library

  # Show Drives and Servers on Desktop
  defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool true
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop     -bool true

  # Desktop View Settings
  defaults write com.apple.finder DesktopViewSettings -dict-add IconViewSettings '''
    {
      arrangeBy            = name;
      backgroundColorBlue  = 1;
      backgroundColorGreen = 1;
      backgroundColorRed   = 1;
      backgroundType       = 0;
      gridOffsetX          = 0;
      gridOffsetY          = 0;
      gridSpacing          = 100;
      iconSize             = 64;
      labelOnBottom        = 0;
      showIconPreview      = 1;
      showItemInfo         = 1;
      textSize             = 12;
      viewOptionsVersion   = 1;
    }
  '''

  # Show Finder Sidebar
  defaults write com.apple.finder ShowSidebar -bool true

  # Show Drives and Servers in Sidebar
  defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks  -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable  -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowServers    -bool true

  # Show Network Devices in Sidebar
  defaults write com.apple.sidebarlists networkbrowser -dict-add CustomListProperties '''
    {
      com.apple.NetworkBrowser.backToMyMacEnabled = 1;
      com.apple.NetworkBrowser.bonjourEnabled     = 1;
      com.apple.NetworkBrowser.connectedEnabled   = 1;
    }
  '''

  # Disable Warning when changing a Extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Disable Warning when emptying Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  # Search Current Folder by Defaults
  defaults write com.apple.finder FXDefaultSearchScope 'SCcf'

  # Disable the “Are you sure you want to open this application?” Dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false


  # Dock, Dashboard & Mission Control

  # Disable Dashboard
  defaults write com.apple.dashboard enabled-state -int 1

  # Increase Mission Control Animation Speed
  defaults write com.apple.dock expose-animation-duration -float 0.125

  # Automatically hide Dock
  defaults write com.apple.dock autohide -bool true

  # Translucent Icons of hidden Applications
  defaults write com.apple.dock showhidden -bool true

}
