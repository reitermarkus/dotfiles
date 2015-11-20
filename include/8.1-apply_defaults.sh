#!/bin/sh


# Apply Defaults

apply_defaults() {

  echo -b 'Applying Defaults …'

  # Reload Preferences
  killall cfprefsd &>/dev/null

  sudo chown -R "${USER}":staff ~/Library/Preferences

}
