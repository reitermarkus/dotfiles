#!/bin/sh


# Mouse & Trackpad Defaults

defaults_mouse_trackpad() {

  echo -b 'Setting defaults for Mouse & Trackpad …'

  # Enable User Preferences
  defaults write com.apple.AppleMultitouchTrackpad                  UserPreferences -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad UserPreferences -bool true
  defaults write com.apple.AppleMultitouchMouse                     UserPreferences -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse    UserPreferences -bool true

  # Enable Clicking and Dragging
  defaults write com.apple.AppleMultitouchTrackpad                  Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults write com.apple.AppleMultitouchTrackpad                  DragLock -bool false
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -bool false
  defaults write com.apple.AppleMultitouchTrackpad                  Dragging -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true

  # Enable Dragging by Tapping
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int  2

  # Enable Right-Click
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string 'TwoButton'
  defaults -currentHost write NSGlobalDomain   com.apple.trackpad.enableSecondaryClick -bool true
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadRightClick -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
  defaults -currentHost write NSGlobalDomain      com.apple.trackpad.trackpadCornerClickBehavior -int 0
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadCornerSecondaryClick -int 0
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0

  # Disable Three-Finger Dragging
  defaults -currentHost write NSGlobalDomain      com.apple.trackpad.threeFingerDragGesture -bool false
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerDrag -bool false
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false

  # Enable Swipe Navigation
  defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
  defaults -currentHost write NSGlobalDomain             com.apple.trackpad.threeFingerHorizSwipeGesture -int 1
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerHorizSwipeGesture -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1

  # Show Notification Center with Two-Finger Swipe from Right Edge
  defaults -currentHost write NSGlobalDomain             com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 3
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

  # Enable Scrolling
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadScroll -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll -bool true
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadHorizScroll -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHorizScroll -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse    MouseVerticalScroll -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse  MouseHorizontalScroll -int 1

  # Enable Momentum-Scrolling
  defaults -currentHost write NSGlobalDomain             com.apple.trackpad.momentumScroll -bool true
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadMomentumScroll -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse       MouseMomentumScroll -bool true

  # Enable Natural Scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

  # Enable Spaces Gestures
  defaults -currentHost write NSGlobalDomain             com.apple.trackpad.fourFingerHorizSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadFourFingerHorizSwipeGesture -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse        MouseTwoFingerHorizSwipeGesture -int 2

  # Enable Hand-Resting
  defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting                  -bool true

  # Enable Rotate Gesture
  defaults -currentHost write NSGlobalDomain      com.apple.trackpad.rotateGesture -bool true
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadRotate -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool true

  # Enable Zoom Gesture
  defaults -currentHost write NSGlobalDomain      com.apple.trackpad.pinchGesture -bool true
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadPinch -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true

  # Enable Intelligent Zooming
  defaults -currentHost write NSGlobalDomain             com.apple.trackpad.twoFingerDoubleTapGesture -int  1
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadTwoFingerDoubleTapGesture -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse       MouseOneFingerDoubleTapGesture -int 1

  # Keep Trackpad enabled when using a Mouse
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.ignoreTrackpadIfMousePresent -bool false

  # Enable Three-Finger Tap Dictionary
  defaults -currentHost write NSGlobalDomain             com.apple.trackpad.threeFingerTapGesture -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerTapGesture -int 2

  # Enable Mission Control and Exposé Gestures
  defaults write com.apple.dock showAppExposeGestureEnabled      -bool true
  defaults write com.apple.dock showMissionControlGestureEnabled -bool true
  defaults -currentHost write NSGlobalDomain             com.apple.trackpad.threeFingerVertSwipeGesture -int 2
  defaults -currentHost write NSGlobalDomain              com.apple.trackpad.fourFingerVertSwipeGesture -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerVertSwipeGesture -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad  TrackpadFourFingerVertSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad                   TrackpadFourFingerVertSwipeGesture -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse         MouseTwoFingerDoubleTapGesture -int 3

  # Enable Launchpad and Show Desktop Gestures
  defaults write com.apple.dock showDesktopGestureEnabled   -bool true
  defaults write com.apple.dock showLaunchpadGestureEnabled -bool true
  defaults -currentHost write NSGlobalDomain        com.apple.trackpad.fourFingerPinchSwipeGesture -int  2
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadFourFingerPinchGesture -int  2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int  2
  defaults -currentHost write NSGlobalDomain        com.apple.trackpad.fiveFingerPinchSwipeGesture -int  2
  defaults write com.apple.AppleMultitouchTrackpad                  TrackpadFiveFingerPinchGesture -int  2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int  2


  killall cfprefsd &>/dev/null

}
