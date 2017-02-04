#!/bin/sh


# Telegram Defaults

defaults_telegram() {

  /usr/bin/defaults write ru.keepcoder.Telegram 'AutomaticDashSubstitutionEnabledTGMessagesTextView' -bool false
  /usr/bin/defaults write ru.keepcoder.Telegram 'AutomaticQuoteSubstitutionEnabledTGMessagesTextView' -bool false

  /usr/bin/killall cfprefsd &>/dev/null

}
