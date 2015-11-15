#!/bin/sh


# Mouse & Trackpad Defaults

defaults_mouse_trackpad() {

  echo -b 'Setting defaults for Mouse & Trackpad …'

  # Enable Clicking and Dragging
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.AppleMultitouchTrackpad DragLock -bool false
  defaults write com.apple.AppleMultitouchTrackpad Dragging -int 1

  # Enable Right-Click
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
  defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string 'TwoButton'

  # Scrolling Options
  defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -bool true
  defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseMomentumScroll   -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseVerticalScroll   -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseHorizontalScroll -int 1

  # Pinch, Rotate and Swipe Gestures
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture       -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture  -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture       -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture   -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting                  -bool true
  defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch                        -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate                       -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag              -bool false
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture        -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture  -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingersRightClick       -int 0
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseOneFingerDoubleTapGesture  -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseTwoFingerDoubleTapGesture  -int 3
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseTwoFingerHorizSwipeGesture -int 2

  # Zoom with Two-Finger Double Tap
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1

  # Show Notification Center with Two-Finger Swipe from Right
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

  # Don't disable Trackpad when using a Mouse
  defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad -int 0

}
