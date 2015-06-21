cecho 'Writing Defaults …' $blue


### Login Window

# Disable Guest Account
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# Hide the Sleep, Restart and Shut Down buttons
sudo defaults write /Library/Preferences/com.apple.loginwindow 'PowerOffDisabled' -bool false
 
# Show Input menu in Login Window
sudo defaults write /Library/Preferences/com.apple.loginwindow 'showInputMenu' -bool true
 
# Hide Password Hints
sudo defaults write /Library/Preferences/com.apple.loginwindow 'RetriesUntilHint' -int 0


### Menubar

# Set Clock Format
defaults write com.apple.menuextra.clock DateFormat          'HH:mm'
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults write com.apple.menuextra.clock IsAnalog            -bool false

# Set Menubar Items
defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"  "/System/Library/CoreServices/Menu Extras/AirPort.menu"  "/System/Library/CoreServices/Menu Extras/Battery.menu"  "/System/Library/CoreServices/Menu Extras/Clock.menu"  "/System/Library/CoreServices/Menu Extras/User.menu"


### Desktop and Finder 

# Show Drives and Servers on Desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

# Desktop View Settings
defaults write com.apple.finder.plist DesktopViewSettings -dict IconViewSettings '<dict><key>arrangeBy</key><string>name</string><key>backgroundColorBlue</key><real>1</real><key>backgroundColorGreen</key><real>1</real><key>backgroundColorRed</key><real>1</real><key>backgroundType</key><integer>0</integer><key>gridOffsetX</key><real>0.0</real><key>gridOffsetY</key><real>0.0</real><key>gridSpacing</key><real>100</real><key>iconSize</key><real>64</real><key>labelOnBottom</key><false/><key>showIconPreview</key><true/><key>showItemInfo</key><true/><key>textSize</key><real>12</real><key>viewOptionsVersion</key><integer>1</integer></dict>'

# Show Finder Sidebar
defaults write com.apple.finder ShowSidebar -bool true

# Show Drives and Servers in Sidebar
defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -bool true
defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks  -bool true
defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable  -bool true
defaults write com.apple.sidebarlists systemitems -dict-add ShowServers    -bool true

# Show Network Devices in Sidebar
defaults write com.apple.sidebarlists networkbrowser -dict CustomListProperties '<dict><key>com.apple.NetworkBrowser.backToMyMacEnabled</key><true/><key>com.apple.NetworkBrowser.bonjourEnabled</key><true/><key>com.apple.NetworkBrowser.connectedEnabled</key><true/></dict>'

# Disable Warning when changing a Extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable Warning when emptying Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Search Current Folder by Defaults
defaults write com.apple.finder FXDefaultSearchScope 'SCcf'


### Dock & Mission Control

# Increase Mission Control Animation Speed
defaults write com.apple.dock expose-animation-duration -float 0.125

# Automatically hide Dock 
defaults write com.apple.dock autohide -bool true


### Safari

# Change Safari's In-Page Search to “contains” instead of “starts with”
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false


### General User Interface

# Expand Save Panel by Default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint    -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2   -bool true


# Reload Menubar and Dock
killall SystemUIServer Dock


### Trackpad

# Enable Clicking and Dragging
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool false
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true

# Enable Right-Click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -integer 0



# Scrolling Options
defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -integer 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -bool true

# Pinch, Rotate and Swipe Gestures
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture       -integer 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture  -integer 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture       -integer 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture   -integer 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting                  -bool    true
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch                        -integer 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate                       -integer 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag              -bool    false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -integer 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture        -integer 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture  -integer 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingersRightClick       -integer 0

# Zoom with Two-Finger Double Tap
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture 1

# Show Notification Center with Two-Finger Swipe from Right
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture = 3

# Don't disable Trackpad when using a Mouse
defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad -integer 0


## Software Update

# Check for Software Updates daily
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 1


### Locate DB

# Start Locate DB Service
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist









