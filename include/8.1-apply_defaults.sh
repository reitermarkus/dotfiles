#!/bin/sh


# Apply Defaults

apply_defaults() {

  echo -b 'Applying Defaults …'

  # Reload Preferences
  killall cfprefsd &>/dev/null

}
