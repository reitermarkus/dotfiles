#!/bin/sh


# Configure Default Settings

cecho 'Writing Defaults …' $blue


### Startup

# Enable Verbose Boot
sudo nvram boot-args='-v'


### Login Window

# Disable Guest Account
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
sudo rm -rf /Users/Guest


# Hide the Sleep, Restart and Shut Down buttons
sudo defaults write /Library/Preferences/com.apple.loginwindow 'PowerOffDisabled' -bool false

# Show Input menu in Login Window
sudo defaults write /Library/Preferences/com.apple.loginwindow 'showInputMenu' -bool true

# Hide Password Hints
sudo defaults write /Library/Preferences/com.apple.loginwindow 'RetriesUntilHint' -int 0


### Languages

# Set System Languages
defaults write -g AppleLanguages -array 'de-AT' 'de' 'en'

# Use Metric Units
defaults write -g AppleLocale -string 'de_AT@currency=EUR'
defaults write -g AppleMeasurementUnits -string 'Centimeters'
defaults write -g AppleMetricUnits -bool true

# Disable Auto Correction
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false


### Date & Time

# Set Time Zone
sudo systemsetup -settimezone 'Europe/Vienna' > /dev/null


### Menubar

# Set Clock Format
defaults write com.apple.menuextra.clock DateFormat          'HH:mm'
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults write com.apple.menuextra.clock IsAnalog            -bool false

# Set Menubar Items
defaults write com.apple.systemuiserver menuExtras -array '/System/Library/CoreServices/Menu Extras/TimeMachine.menu' '/System/Library/CoreServices/Menu Extras/Bluetooth.menu' '/System/Library/CoreServices/Menu Extras/AirPort.menu' '/System/Library/CoreServices/Menu Extras/Battery.menu' '/System/Library/CoreServices/Menu Extras/Clock.menu' '/System/Library/CoreServices/Menu Extras/User.menu'

# Show Battery Percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true

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


### Dock, Dashboard & Mission Control

# Disable Dashboard
defaults write com.apple.dashboard enabled-state -int 1

# Increase Mission Control Animation Speed
defaults write com.apple.dock expose-animation-duration -float 0.125

# Automatically hide Dock
defaults write com.apple.dock autohide -bool true

# Translucent Icons of hidden Applications
defaults write com.apple.dock showhidden -bool true


### Safari

# Change Safari's In-Page Search to “contains” instead of “starts with”
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false


### General User Interface

# Expand Save Panel by Default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint    -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2   -bool true

# Disable Font Smoothing globally
defaults write -g AppleFontSmoothing -int 0


# Reload Menubar and Dock
killall SystemUIServer Dock


### Trackpad

# Enable Clicking and Dragging
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool false
defaults write com.apple.AppleMultitouchTrackpad Dragging -int 1

# Enable Right-Click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0



# Scrolling Options
defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -bool true

# Pinch, Rotate and Swipe Gestures
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture       -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture  -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture       -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture   -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting                  -bool    true
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch                        -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate                       -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag              -bool    false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture        -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture  -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingersRightClick       -int 0

# Zoom with Two-Finger Double Tap
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1

# Show Notification Center with Two-Finger Swipe from Right
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

# Don't disable Trackpad when using a Mouse
defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad -int 0


## Software Update

# Check for Software Updates daily
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 1


### Locate DB

# Start Locate DB Service
if sudo launchctl list com.apple.locate &>/dev/null; then
  cecho 'Locate DB alread enabled.' $green
else
  cecho 'Enabling Locate DB …' $blue
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
fi


### Terminal

defaults delete com.apple.Terminal 'Window Settings'
defaults write com.apple.Terminal 'Window Settings' -dict-add Basic '<dict><key>BackgroundAlphaInactive</key><real>0.75</real><key>BackgroundBlur</key><real>1</real><key>BackgroundBlurInactive</key><real>1</real><key>BackgroundColor</key><data>YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA9VJG51bGzTCQoLDA0OV05TV2hpdGVcTlNDb2xvclNwYWNlViRjbGFzc0YxIDAuOQAQBIAC0hAREhNaJGNsYXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hpdmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhQXWRrbW90f4iQk5yusbYAAAAAAAABAQAAAAAAAAAZAAAAAAAAAAAAAAAAAAAAuA==</data><key>BackgroundSettingsForInactiveWindows</key><true/><key>Font</key><data>YnBsaXN0MDDUAQIDBAUGGBlYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKQHCBESVSRudWxs1AkKCwwNDg8QVk5TU2l6ZVhOU2ZGbGFnc1ZOU05hbWVWJGNsYXNzI0AmAAAAAAAAEBCA			AoADXU1lbmxvLVJlZ3VsYXLSExQVFlokY2xhc3NuYW1lWCRjbGFzc2VzVk5TRm9udKIVF1hOU09iamVjdF8QD05TS2V5ZWRBcmNoaXZlctEaG1Ryb290gAEIERojLTI3PEJLUltiaXJ0dniGi5afpqmyxMfMAAAAAAAAAQEAAAAAAAAAHAAAAAAAAAAAAAAAAAAAAM4=</data><key>FontWidthSpacing</key><real>1.004032258064516</real><key>FontAntialias</key><true/><key>FontWidthSpacing</key><real>1.004032258064516</real><key>ShowActiveProcessInTitle</key><true/><key>ShowCommandKeyInTitle</key><false/><key>ShowDimensionsInTitle</key><false/><key>ShowRepresentedURLInTitle</key><true/><key>ShowRepresentedURLPathInTitle</key><false/><key>ShowShellCommandInTitle</key><false/><key>ShowTTYNameInTitle</key><false/><key>ShowWindowSettingsNameInTitle</key><false/><key>name</key><string>Standard</string><key>shellExitAction</key><integer>1</integer><key>ProfileCurrentVersion</key><real>2.04</real><key>name</key><string>Basic</string></dict>'
defaults write com.apple.Terminal 'Default Window Settings' Basic
