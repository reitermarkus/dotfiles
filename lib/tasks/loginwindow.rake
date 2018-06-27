require 'laptop?'
require 'user'
require 'plist'
require 'digest'

task :loginwindow => [:'loginwindow:defaults', :'loginwindow:logout_guest_on_idle']

namespace :loginwindow do
  task :defaults do
    defaults '/Library/Preferences/com.apple.loginwindow' do
      # Show the “Sleep”, “Restart” and “Shut Down” buttons.
      write 'PowerOffDisabled', false

      # Show input menu.
      write 'showInputMenu', true

      # Never show password hints.
      write 'RetriesUntilHint', 0

      # Show login text.
      write 'LoginwindowText', if laptop?
        "If found, please contact the owner:\nme@reitermark.us\n@reitermarkus"
      else
        ''
      end

      # Apply login text on FileVault pre-boot screen.
      command sudo, '/bin/rm', '-f', '/System/Library/Caches/com.apple.corestorage/EFILoginLocalizations/preferences.efires'

      # Disable the Guest account.
      write 'GuestEnabled', false
      command sudo, '/bin/rm', '-rf', '/Users/Guest'
    end

    defaults '/Library/Preferences/com.apple.AppleFileServer' do
      write 'guestAccess', false
    end

    defaults '/Library/Preferences/SystemConfiguration/com.apple.smb.server' do
      write 'AllowGuestAccess', false
    end

    # Save open windows on logout.
    defaults 'com.apple.loginwindow' do
      write 'TALLogoutSavesState', true
    end

    # Capitalize user name.
    if USER != 'Markus'
      command sudo, '/usr/bin/dscl', '.', 'create', HOME, 'RecordName', 'Markus'
    end

    if HOME != '/Users/Markus'
      command sudo, '/usr/bin/dscl', '.', 'create', HOME, 'NFSHomeDirectory', '/Users/Markus'
      command sudo, '/bin/mv', HOME, '/Users/Markus'
    end

    user_picture = "/Library/User Pictures/#{USER}"

    command sudo, '/usr/bin/dscl', '.', 'delete', HOME, 'JPEGPhoto'
    command sudo, '/usr/bin/dscl', '.', 'delete', HOME, 'Picture'

    local_picture = Dir.glob(File.expand_path("~/Library/User Pictures/#{USER}*")).first

    command sudo, '/bin/rm', '-f', user_picture

    # If no local picture is found, use Gravatar.
    if local_picture
      puts ANSI.blue { "Setting user picture to #{File.basename(local_picture)} …" }
      command sudo, '/bin/cp', '-f', local_picture, user_picture
    else
      puts ANSI.blue { "Setting user picture to Gravatar picture …" }
      gravatar_id = Digest::MD5.hexdigest('me@reitermark.us')
      command sudo, '/usr/bin/curl', '-o', user_picture, '--silent', '--location', "https://gravatar.com/avatar/#{gravatar_id}.png?s=256"
    end

    command sudo, '/usr/bin/dscl', '.', 'append', HOME, 'Picture', user_picture

    command sudo, '/usr/sbin/chown', "#{USER}:staff", user_picture
    command sudo, '/bin/chmod', 'a=r,u+w', user_picture
  end

  desc 'Automatically log out the Guest account when idle.'
  task :logout_guest_on_idle do
    launchd_name = 'com.apple.LogoutGuestOnIdle'
    launchd_plist = "/Library/LaunchAgents/#{launchd_name}.plist"

    plist = {
      'Label' => launchd_name,
      'RunAtLoad' => true,
      'StartInterval' => 10,
      'ProgramArguments' => [
        '/bin/bash', '-c', <<~SH
          gui_user="$(/usr/bin/stat -f '%Su' /dev/console)";

          if [ "$gui_user" = "Guest" ]; then
            idle_time="$(/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/awk '/HIDIdleTime/ {print int($NF / 1000000000); exit}')"

            if [ "$idle_time" -ge 20 ]; then
              '/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession' -suspend
            fi
          fi
        SH
      ]
    }

    capture sudo, '/usr/bin/tee', launchd_plist, input: plist.to_plist

    command sudo, '/usr/sbin/chown', 'root:admin', launchd_plist
    command sudo, '/bin/chmod', '755', launchd_plist
  end
end
