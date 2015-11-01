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
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.finder.plist \
    -c 'Delete :DesktopViewSettings:IconViewSettings:arrangeBy                       ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:arrangeBy            string name' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:backgroundColorBlue             ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:backgroundColorBlue       real 1' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:backgroundColorGreen            ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:backgroundColorGreen      real 1' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:backgroundColorRed              ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:backgroundColorRed        real 1' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:backgroundType                  ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:backgroundType         integer 0' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:gridOffsetX                     ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:gridOffsetX               real 0' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:gridOffsetY                     ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:gridOffsetY               real 0' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:gridSpacing                     ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:gridSpacing               real 0' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:iconSize                        ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:iconSize                 real 64' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:labelOnBottom                   ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:labelOnBottom         bool false' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:showIconPreview                 ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:showIconPreview        bool true' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:showItemInfo                    ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:showItemInfo           bool true' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:textSize                        ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:textSize                 real 12' \
    -c 'Delete :DesktopViewSettings:IconViewSettings:viewOptionsVersion              ' \
    -c 'Add    :DesktopViewSettings:IconViewSettings:viewOptionsVersion     integer 1' \
  &>/dev/null \
  |>/dev/null # Silences “Abort trap: 6” error when more than 14 commands are passed.

  # Show Finder Sidebar
  defaults write com.apple.finder ShowSidebar -bool true

  # Show Drives and Servers in Sidebar
  defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks  -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable  -bool true
  defaults write com.apple.sidebarlists systemitems -dict-add ShowServers    -bool true

  # Show Network Devices in Sidebar
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.sidebarlists.plist \
    -c 'Delete :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.backToMyMacEnabled          ' \
    -c 'Add    :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.backToMyMacEnabled bool true' \
    -c 'Delete :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.bonjourEnabled              ' \
    -c 'Add    :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.bonjourEnabled     bool true' \
    -c 'Delete :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.connectedEnabled            ' \
    -c 'Add    :networkbrowser:CustomListProperties:com.apple.NetworkBrowser.connectedEnabled   bool true' \
  &>/dev/null

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
