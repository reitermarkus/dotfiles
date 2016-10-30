defaults_finder() {

  # Finder

  # Hide “/opt” folder.
  if [ -d /opt ]; then
    /usr/bin/sudo -E -- chflags hidden /opt
  fi

  # Show “Library” folder.
  chflags nohidden "${HOME}/Library"

  # Show Drives and Servers on Desktop
  /usr/bin/defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool true
  /usr/bin/defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  /usr/bin/defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool true
  /usr/bin/defaults write com.apple.finder ShowMountedServersOnDesktop     -bool true

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
  ; /usr/bin/killall cfprefsd &>/dev/null

  # Info Viewer Fields
  /usr/bin/defaults write com.apple.finder FXInfoPanesExpanded -dict-add General    -bool true
  /usr/bin/defaults write com.apple.finder FXInfoPanesExpanded -dict-add MetaData   -bool false
  /usr/bin/defaults write com.apple.finder FXInfoPanesExpanded -dict-add Name       -bool true
  /usr/bin/defaults write com.apple.finder FXInfoPanesExpanded -dict-add OpenWith   -bool true
  /usr/bin/defaults write com.apple.finder FXInfoPanesExpanded -dict-add Comments   -bool false
  /usr/bin/defaults write com.apple.finder FXInfoPanesExpanded -dict-add Preview    -bool false
  /usr/bin/defaults write com.apple.finder FXInfoPanesExpanded -dict-add Privileges -bool true

  # Show Finder Sidebar
  /usr/bin/defaults write com.apple.finder ShowSidebar       -bool true
  /usr/bin/defaults write com.apple.finder ShowStatusBar     -bool true
  /usr/bin/defaults write com.apple.finder ShowPreviewPane   -bool true

  # Show Drives and Servers in Sidebar
  /usr/bin/defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -bool true
  /usr/bin/defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks  -bool true
  /usr/bin/defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable  -bool true
  /usr/bin/defaults write com.apple.sidebarlists systemitems -dict-add ShowServers    -bool true

  # Show Network Devices in Sidebar
  /usr/bin/defaults write com.apple.sidebarlists networkbrowser -dict-add CustomListProperties '''
    <dict>
      <key>backToMyMacEnabled</key><true/>
      <key>bonjourEnabled</key><true/>
      <key>connectedEnabled</key><true/>
    </dict>
  '''; /usr/bin/killall cfprefsd &>/dev/null

  # Disable Warning when changing a Extension
  /usr/bin/defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Disable Warning when emptying Trash
  /usr/bin/defaults write com.apple.finder WarnOnEmptyTrash -bool false

  # Search Current Folder by Defaults
  /usr/bin/defaults write com.apple.finder FXDefaultSearchScope 'SCcf'

  # Use column view in all Finder windows by default.
  /usr/bin/defaults write com.apple.finder FXPreferredViewStyle -string 'clmv'

  # Open new Finder windows with User folder.
  /usr/bin/defaults write com.apple.finder NewWindowTarget -string 'PfHm'

  # Disable the “Are you sure you want to open this application?” Dialog
  /usr/bin/defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable Gatekeeper
  /usr/bin/sudo -E -- /usr/sbin/spctl --master-disable

  # Enable spring-loading directories and decrease default delay.
  /usr/bin/defaults write NSGlobalDomain com.apple.springing.enabled -bool  true
  /usr/bin/defaults write NSGlobalDomain com.apple.springing.delay   -float 0.2

  # Disable Disk Image Verification
  /usr/bin/defaults write com.apple.frameworks.diskimages skip-verify        -bool true
  /usr/bin/defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  /usr/bin/defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

  /usr/bin/killall cfprefsd &>/dev/null

}
