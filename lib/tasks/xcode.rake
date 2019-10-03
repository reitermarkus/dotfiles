# frozen_string_literal: true

require 'defaults'

namespace :xcode do
  desc 'Install Xcode Command Line Utilities'
  task :command_line_utilities do
    if File.directory?('/Library/Developer/CommandLineTools')
      puts ANSI.green { 'Command Line Developer Tools are already installed.' }
    else
      puts ANSI.blue { 'Installing Command Line Developer Tools …' }

      placeholder = '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
      FileUtils.touch placeholder

      begin
        out, = command '/usr/sbin/softwareupdate', '--list'
        name = out.scan(/^\s*\*\s*(Command Line Tools.*)\s+?$/).flatten.last

        raise 'Command Line Tools are not available for download.' unless name

        command '/usr/sbin/softwareupdate', '--verbose', '--install', name
      ensure
        FileUtils.rm placeholder
      end
    end

    pkg = '/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg'
    header = '/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/include/ruby-2.3.0/universal-darwin18/ruby/config.h'

    command sudo, 'installer', '-pkg', pkg, '-target', '/' if File.exist?(pkg) && !File.exist?(header)
  end

  desc 'Accept the Xcode License Agreement'
  task :accept_license => [:mas] do
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
      write 'DVTTextEditorTrimTrailingWhitespace', true
      write 'DVTTextEditorTrimWhitespaceOnlyLines', true
      write 'NSNavPanelExpandedStateForSaveMode', true
    end
  end
end
