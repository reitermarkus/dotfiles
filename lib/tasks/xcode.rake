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
        out, = command '/usr/sbin/softwareupdate', '--list'
        name = out.scan(/^\s*\*\s*(Command Line Tools.*)\s+?$/).flatten.last
        command '/usr/sbin/softwareupdate', '--verbose', '--install', name
      ensure
        FileUtils.rm placeholder
      end
    end
  end

  desc 'Accept the Xcode License Agreement'
  task :accept_license => [:mas]  do
    installed = begin
      capture('/usr/bin/xcode-select', '--print-path').include?('/Xcode.app/')
    rescue NonZeroExit
      false
    end

    next unless installed

    ANSI.blue { 'Accepting Xcode License Agreement …' }
    command sudo, '/usr/bin/xcodebuild', '-license', 'accept'
  end

  desc 'Configure Xcode Defaults'
  task :defaults do
    puts ANSI.blue { 'Configuring Xcode …' }

    defaults 'com.apple.dt.xcode' do
      write 'DVTTextIndentUsingTabs', false
      write 'DVTTextIndentTabWidth', 2
      write 'DVTTextIndentWidth', 2
      write 'DVTTextShowLineNumbers', true
      write 'NSNavPanelExpandedStateForSaveMode', true
    end
  end
end
