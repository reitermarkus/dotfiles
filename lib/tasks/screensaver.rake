# frozen_string_literal: true

require 'defaults'
require 'json'
require 'killall'

task :screensaver => [:'screensaver:defaults', :'screensaver:aerial']

namespace :screensaver do
  task :defaults do
    puts ANSI.blue { 'Configuring screensaver settings …' }

    defaults 'com.apple.screensaver' do
      # Ask for password after screensaver.
      write 'askForPassword', true

      # Set password delay.
      write 'askForPasswordDelay', laptop? ? 60 : 300
    end

    defaults current_host: 'com.apple.screensaver' do
      # Set screensaver delay.
      write 'idleTime', laptop? ? 120 : 300

      # Don't show Clock on Screensaver
      write 'showClock', false
    end

    killall 'cfprefsd'
    killall 'Dock', signal: 'HUP'
  end

  task :aerial => [:'brew:casks_and_formulae'] do
    defaults current_host: 'com.JohnCoates.Aerial' do
      write 'timeMode', 1
      write 'videoFormat', 2
      write 'synchronizedMode', true
    end

    defaults current_host: 'com.apple.screensaver' do
      write 'moduleDict', {
        'moduleName' => 'Aerial',
        'path' => '/Library/Screen Savers/Aerial.saver',
        'type' => 0,
      }
    end
  end
end
