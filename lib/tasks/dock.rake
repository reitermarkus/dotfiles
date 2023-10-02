# frozen_string_literal: true

require 'command'
require 'defaults'
require 'killall'
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
      write 'expose-group-apps', true

      # Don't rearrange Spaces based on most recent use.
      write 'mru-spaces', false
    end

    # Disable Dashboard.
    defaults 'com.apple.dashboard' do
      write 'enabled-state', 1
    end

    desktop_pictures_dir = File.expand_path('~/Library/Desktop Pictures')
    defaults 'com.apple.systempreferences' do
      write 'DSKDesktopPrefPane', {
        'UserFolderPaths' => [desktop_pictures_dir],
      }
    end

    command 'sqlite3', File.expand_path('~/Library/Application Support/Dock/desktoppicture.db'), <<~SQL
      DELETE FROM data;
      DELETE FROM preferences;
      VACUUM;
      INSERT INTO data VALUES('#{desktop_pictures_dir}/current');
      INSERT INTO preferences VALUES(1, 1, 1);
      INSERT INTO preferences VALUES(1, 1, 2);
      INSERT INTO preferences VALUES(1, 1, 3);
      INSERT INTO preferences VALUES(1, 1, 4);
    SQL

    killall 'cfprefsd'
  end

  task :icons do
    puts ANSI.blue { 'Setting up Dock icons …' }

    dock_items = [
      '{/System,}/Applications/Launchpad.app',
      '/Applications/Safari.app',
      '{/System,}/Applications/Mail.app',
      '{/System,}/Applications/Notes.app',
      '{/System,}/Applications/Messages.app',
      '/Applications/Telegram.app',
      '{/System/Applications/Music,/Applications/iTunes}.app',
      '{/System,}/Applications/Photos.app',
      '{/System,}/Applications/Books.app',
      '/Applications/Pages.app',
      '/Applications/Numbers.app',
      '/Applications/Parallels Desktop.app',
      '/Applications/Xcode.app',
      '{/System,}/Applications/Utilities/Terminal.app',
      '/Applications/TextMate.app',
      '/Applications/MacDown.app',
      '/Applications/Fork.app',
      '/Applications/Affinity Photo.app',
      '/Applications/Affinity Designer.app',
    ].flat_map { |path| Pathname.glob(path) }

    defaults 'com.apple.dock' do
      write 'persistent-apps', dock_items.map { |path|
        {
          GUID: capture('uuidgen'),
          'tile-data': {
            'file-data': {
              _CFURLStringType: 0,
              _CFURLString: path.to_path,
            },
          },
        }
      }
    end

    killall 'cfprefsd'
    killall 'Dock'
  end
end
