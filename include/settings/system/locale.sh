defaults_locale() {

  # Localization
  echo -b 'Setting defaults for Localization …'

  # Set System Languages
  sudo languagesetup -langspec de 1>/dev/null
  /usr/bin/defaults write NSGlobalDomain AppleLanguages -array 'de-AT' 'de' 'en'

  # Use Metric Units
  /usr/bin/defaults write NSGlobalDomain AppleLocale -string 'de_AT@currency=EUR'
  /usr/bin/defaults write NSGlobalDomain AppleMeasurementUnits -string 'Centimeters'
  /usr/bin/defaults write NSGlobalDomain AppleMetricUnits -bool true

  # Disable Auto Correction
  /usr/bin/defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Set Time Zone
  sudo systemsetup -settimezone 'Europe/Vienna' 1>/dev/null

}
