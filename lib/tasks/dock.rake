require 'command'
require 'defaults'
require 'plist'

task :dock => [:'dock:defaults', :'dock:icons']

namespace :dock do
  task :defaults do
    defaults 'com.apple.dock' do
      # Minimize windows behind Dock icon.
      write 'minimize-to-application', true

      # Automatically hide Dock.
      write 'autohide', true

      # Translucent icons of hidden applications.
      write 'showhidden', true

      # Increase Mission Control animation speed.
      write 'expose-animation-duration', 0.125
      write 'expose-group-apps',  true
    end

    # Disable Dashboard.
    defaults 'com.apple.dashboard' do
      write 'enabled-state', 1
    end

    desktop_pictures_dir = File.expand_path('~/Library/Desktop Pictures')
    defaults 'com.apple.systempreferences' do
      write 'DSKDesktopPrefPane', {
        'UserFolderPaths' => [desktop_pictures_dir]
      }
    end

    command '/usr/bin/sqlite3', File.expand_path('~/Library/Application Support/Dock/desktoppicture.db'), <<~SQL
      DELETE FROM data;
      DELETE FROM preferences;
      VACUUM;
      INSERT INTO data VALUES('#{desktop_pictures_dir}/current');
      INSERT INTO preferences VALUES(1, 1, 1);
      INSERT INTO preferences VALUES(1, 1, 2);
      INSERT INTO preferences VALUES(1, 1, 3);
      INSERT INTO preferences VALUES(1, 1, 4);
    SQL

    capture '/usr/bin/killall', 'cfprefsd'
  end

  task :icons => [:'brew:casks_and_formulae'] do
    puts ANSI.blue { 'Setting up Dock icons …' }

    defaults_apps = [
      ['System Preferences', 'Systemeinstellungen'],
      ['App Store'],
      ['Maps', 'Karten'],
      ['Notes'],
      ['Photos'],
      ['Messages'],
      ['Contacts', 'Kontakte'],
      ['Calendar', 'Kalender'],
      ['Reminders', 'Erinnerungen'],
      ['FaceTime'],
      ['Feedback Assistant', 'Feedback-Assistent'],
      ['Siri'],
    ].flatten

    capture 'dockutil', '--no-restart', defaults_apps.flat_map { |app| ['--remove', app] }

    dock_items = [
      '/Applications/Launchpad.app',
      '/Applications/Safari.app',
      '/Applications/Mail.app',
      '/Applications/Reeder.app',
      '/Applications/Notes.app',
      '/Applications/Messages.app',
      '/Applications/Telegram.app',
      '/Applications/iTunes.app',
      '/Applications/Photos.app',
      '/Applications/iBooks.app',
      '/Applications/Pages.app',
      '/Applications/Numbers.app',
      '/Applications/Parallels Desktop.app',
      '/Applications/Xcode.app',
      '/Applications/Utilities/Terminal.app',
      '/Applications/TextMate.app',
      '/Applications/MacDown.app',
      '/Applications/Tower.app',
      '/Applications/Adobe Photoshop CC 2015/Adobe Photoshop CC 2015.app',
      '/Applications/Adobe Illustrator CC 2015/Adobe Illustrator.app',
    ]

    def name(path)
      @name ||= {}
      return @name[path] if @name.key?(path)

      de_strings = "#{path}/Contents/Resources/de.lproj/InfoPlist.strings"

      if File.exist?(de_strings)
        plist = Plist.parse_xml(capture '/usr/bin/plutil', '-convert', 'xml1', '-o', '-', de_strings)
        return @name[path] = plist['CFBundleDisplayName'] if plist.key?('CFBundleDisplayName')
      end

      @name[path] = File.basename(path, '.app')
    end

    [nil, *dock_items.select(&File.method(:exist?))].each_cons(2) do |previous_path, path|
      position_args = if previous_path
        ['--after', name(previous_path)]
      else
        ['--position', 'beginning']
      end

      puts name(path)

      command 'dockutil', '--no-restart', '--add', path, '--label', name(path), '--replacing', name(path), position_args
    end

    capture '/usr/bin/killall', 'cfprefsd'
    capture '/usr/bin/killall', 'Dock'
  end
end
