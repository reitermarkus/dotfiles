require 'defaults'

namespace :xcode do
  desc 'Install Xcode Command Line Utilities'
  task :command_line_utilities do
    installed = begin
      capture '/usr/bin/xcode-select', '--print-path'
    rescue NonZeroExit
      false
    end

    if installed
      puts ANSI.green { 'Command Line Developer Tools are already installed.' }
    else
      puts ANSI.blue { 'Installing Command Line Developer Tools …' }

      placeholder = '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
      FileUtils.touch placeholder

      begin
        name = capture('/usr/sbin/softwareupdate', '--list')
                 .scan(/^.*\*\s*(Command Line Tools.+)\s*$/).last
        command '/usr/sbin/softwareupdate', '--verbose', '--install', name
      ensure
        FileUtils.rm placeholder
      end
    end
  end

  desc 'Accept the Xcode License Agreement'
  task :accept_license do
    command sudo, 'xcodebuild', '-license', 'accept'
  end

  desc 'Configure Xcode Defaults'
  task :defaults do
    defaults 'com.apple.dt.xcode', 'DVTTextIndentUsingTabs', false
    defaults 'com.apple.dt.xcode', 'DVTTextIndentTabWidth', 2
    defaults 'com.apple.dt.xcode', 'DVTTextIndentWidth', 2
    defaults 'com.apple.dt.xcode', 'DVTTextShowLineNumbers', true
    defaults 'com.apple.dt.xcode', 'NSNavPanelExpandedStateForSaveMode', true
  end
end
