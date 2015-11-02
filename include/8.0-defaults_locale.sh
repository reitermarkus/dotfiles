#!/bin/sh


# Localization Defaults

defaults_locale() {


  ### Languages

  # Set System Languages
  sudo languagesetup -langspec de &>/dev/null
  defaults write NSGlobalDomain AppleLanguages -array 'de-AT' 'de' 'en'

  # Use Metric Units
  defaults write NSGlobalDomain AppleLocale -string 'de_AT@currency=EUR'
  defaults write NSGlobalDomain AppleMeasurementUnits -string 'Centimeters'
  defaults write NSGlobalDomain AppleMetricUnits -bool true

  # Disable Auto Correction
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


  ### Date & Time

  # Set Time Zone
  sudo systemsetup -settimezone 'Europe/Vienna' &>/dev/null


}
