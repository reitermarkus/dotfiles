# frozen_string_literal: true

task :mouse_trackpad do
  # Enable user preferences.
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'UserPreferences', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'UserPreferences', true
  end
  defaults 'com.apple.AppleMultitouchMouse' do
    write 'UserPreferences', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.mouse' do
    write 'UserPreferences', true
  end

  # Enable clicking and dragging.
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'Clicking', true
    write 'DragLock', false
    write 'Dragging', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'Clicking', true
    write 'DragLock', false
    write 'Dragging', true
  end

  defaults current_host: 'NSGlobalDomain' do
    # Enable Dragging by Tapping
    write 'com.apple.mouse.tapBehavior', 2

    # Enable Right-Click
    write 'com.apple.trackpad.enableSecondaryClick', true
    write 'com.apple.trackpad.trackpadCornerClickBehavior', 0
  end

  # Enable Right-Click
  defaults 'com.apple.driver.AppleBluetoothMultitouch.mouse' do
    write 'MouseButtonMode', 'TwoButton'
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadRightClick', true
    write 'TrackpadCornerSecondaryClick', 0
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadRightClick', true
    write 'TrackpadCornerSecondaryClick', 0
  end

  # Disable Three-Finger Dragging
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.threeFingerDragGesture', false
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadThreeFingerDrag', false
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadThreeFingerDrag', false
  end

  # Enable Swipe Navigation
  defaults 'NSGlobalDomain' do
    write 'AppleEnableSwipeNavigateWithScrolls', true
  end
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.threeFingerHorizSwipeGesture', 1
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadThreeFingerHorizSwipeGesture', 1
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadThreeFingerHorizSwipeGesture', 1
  end

  # Show Notification Center with Two-Finger Swipe from Right Edge
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture', 3
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadTwoFingerFromRightEdgeSwipeGesture', 3
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadTwoFingerFromRightEdgeSwipeGesture', 3
  end

  # Enable Scrolling
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadScroll', true
    write 'TrackpadHorizScroll', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadScroll', true
    write 'TrackpadHorizScroll', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.mouse' do
    write 'MouseVerticalScroll', true
    write 'MouseHorizontalScroll', true
  end

  # Enable Momentum-Scrolling
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.momentumScroll', true
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadMomentumScroll', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadMomentumScroll', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.mouse' do
    write 'MouseMomentumScroll', true
  end

  # Enable natural scrolling.
  defaults 'NSGlobalDomain' do
    write 'com.apple.swipescrolldirection', true
  end

  # Enable Spaces gestures.
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.fourFingerHorizSwipeGesture', 2
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadFourFingerHorizSwipeGesture', 2
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadFourFingerHorizSwipeGesture', 2
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.mouse' do
    write 'MouseTwoFingerHorizSwipeGesture', 2
  end

  # Enable hand-resting.
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadHandResting', true
  end

  # Enable Rotate gesture.
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.rotateGesture', true
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadRotate', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadRotate', true
  end

  # Enable Zoom gesture.
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.pinchGesture', true
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadPinch', true
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadPinch', true
  end

  # Enable intelligent zooming.
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.twoFingerDoubleTapGesture', 1
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadTwoFingerDoubleTapGesture', 1
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadTwoFingerDoubleTapGesture', 1
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.mouse' do
    write 'MouseOneFingerDoubleTapGesture', 1
  end

  # Keep Trackpad enabled when using a Mouse
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.ignoreTrackpadIfMousePresent', false
  end

  # Enable Three-Finger Tap Dictionary
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.threeFingerTapGesture', 2
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadThreeFingerTapGesture', 2
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadThreeFingerTapGesture', 2
  end

  # Enable Mission Control and Exposé gestures.
  defaults 'com.apple.dock' do
    write 'showAppExposeGestureEnabled', true
    write 'showMissionControlGestureEnabled', true
  end
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.threeFingerVertSwipeGesture', 2
    write 'com.apple.trackpad.fourFingerVertSwipeGesture', 2
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadThreeFingerVertSwipeGesture', 2
    write 'TrackpadFourFingerVertSwipeGesture', 2
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadThreeFingerVertSwipeGesture', 2
    write 'TrackpadFourFingerVertSwipeGesture', 2
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.mouse' do
    write 'MouseTwoFingerDoubleTapGesture', 3
  end

  # Enable Launchpad and Show Desktop gestures.
  defaults 'com.apple.dock' do
    write 'showDesktopGestureEnabled', true
    write 'showLaunchpadGestureEnabled', true
  end
  defaults current_host: 'NSGlobalDomain' do
    write 'com.apple.trackpad.fourFingerPinchSwipeGesture', 2
    write 'com.apple.trackpad.fiveFingerPinchSwipeGesture', 2
  end
  defaults 'com.apple.AppleMultitouchTrackpad' do
    write 'TrackpadFourFingerPinchGesture', 2
    write 'TrackpadFiveFingerPinchGesture', 2
  end
  defaults 'com.apple.driver.AppleBluetoothMultitouch.trackpad' do
    write 'TrackpadFourFingerPinchGesture', 2
    write 'TrackpadFiveFingerPinchGesture', 2
  end

  capture '/usr/bin/killall', 'cfprefsd'
end
