#!/bin/sh


# Apply Defaults

apply_defaults() {

  echo -b 'Applying Defaults …'

  # Reload Dock
  killall Dock &>/dev/null

  # Reload Menubar
  killall SystemUIServer &>/dev/null

}
