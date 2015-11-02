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
  defaults write com.apple.finder.plist DesktopViewSettings -dict-add IconViewSettings '''
    <dict>
      <key>arrangeBy</key><string>name</string>
      <key>backgroundColorBlue</key><real>1</real>
      <key>backgroundColorGreen</key><real>1</real>
      <key>backgroundColorRed</key><real>1</real>
      <key>backgroundType</key><integer>0</integer>
      <key>gridOffsetX</key><real>0.0</real>
      <key>gridOffsetY</key><real>0.0</real>
      <key>gridSpacing</key><real>100</real>
      <key>iconSize</key><real>64</real>
      <key>labelOnBottom</key><false/>
      <key>showIconPreview</key><true/>
      <key>showItemInfo</key><true/>
      <key>textSize</key><real>12</real>
      <key>viewOptionsVersion</key><integer>1</integer>
    </dict>
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
    <dict>
      <key>com.apple.NetworkBrowser.backToMyMacEnabled</key><true/>
      <key>com.apple.NetworkBrowser.bonjourEnabled</key><true/>
      <key>com.apple.NetworkBrowser.connectedEnabled</key><true/>
    </dict>
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
