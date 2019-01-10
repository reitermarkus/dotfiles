# frozen_string_literal: true

require 'defaults'

task :ui do
  defaults 'NSGlobalDomain' do
    # Enable Dark Mode
    write 'AppleInterfaceStyle', 'Dark'

    # Expand Save Panel by Default
    write 'NSNavPanelExpandedStateForSaveMode', true
    write 'NSNavPanelExpandedStateForSaveMode2', true
    write 'PMPrintingExpandedStateForPrint', true
    write 'PMPrintingExpandedStateForPrint2', true

    # Keep Open Windows on Quit
    write 'NSQuitAlwaysKeepsWindows', true

    # Disable Font Smoothing
    write 'AppleFontSmoothing', 0
  end

  # Enable Help Viewer Non-Floating Mode
  defaults 'com.apple.helpviewer' do
    write 'DevMode', true
  end
end
