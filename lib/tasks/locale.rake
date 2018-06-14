task :locale do
  # Set System Languages
  capture sudo, 'languagesetup', '-langspec', 'de'

  defaults 'NSGlobalDomain' do
    write 'AppleLanguages', %w[
      de-AT
      de
      en
    ]
  end

  defaults 'NSGlobalDomain' do
    # Use Metric Units
    write 'AppleLocale', 'de_AT@currency=EUR'
    write 'AppleMeasurementUnits', 'Centimeters'
    write 'AppleMetricUnits', true

    # Disable Auto Correction
    write 'NSAutomaticSpellingCorrectionEnabled', false
  end

  # Set Time Zone
  capture sudo, 'systemsetup', '-settimezone', 'Europe/Vienna'
end
