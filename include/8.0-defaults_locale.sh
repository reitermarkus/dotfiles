#!/bin/sh


# Localization Defaults

defaults_locale() {


  ### Languages

  # Set System Languages
  sudo languagesetup -langspec de &>/dev/null
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


}
