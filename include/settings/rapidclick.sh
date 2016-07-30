#!/bin/sh


# Safari Defaults

defaults_rapidclick() {

  # Disable Welcome Message
  /usr/bin/defaults write com.pilotmoon.rapidclick HasRunBefore -bool true

  # Keyboard Shortcut ⇧⌘C (Shift-Cmd-C)
  /usr/bin/defaults write com.pilotmoon.rapidclick StartStopKey -dict-add modifiers -integer 768
  /usr/bin/defaults write com.pilotmoon.rapidclick StartStopKey -dict-add keyCode -integer 8

}
