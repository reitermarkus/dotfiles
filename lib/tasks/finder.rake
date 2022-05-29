# frozen_string_literal: true

require 'command'
require 'defaults'
require 'killall'

task :finder => :'brew:casks_and_formulae' do
  # Hide “/opt” folder.
  command sudo, '/usr/bin/chflags', 'hidden', '/opt' if File.directory?('/opt')

  # Show “Library” folder.
  command '/usr/bin/chflags', 'nohidden', File.expand_path('~/Library')

  # Don't show eject notifications.
  defaults '/Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist' do
    previous_value = read 'DADisableEjectNotification'

    write 'DADisableEjectNotification', true

    if previous_value != true
      command sudo, '/bin/launchctl', 'kickstart', '-k', 'system/com.apple.diskarbitrationd'
    end
  end

  defaults 'com.apple.finder' do
    # Show drives and servers on desktop.
    write 'ShowHardDrivesOnDesktop', true
    write 'ShowExternalHardDrivesOnDesktop', true
    write 'ShowRemovableMediaOnDesktop', true
    write 'ShowMountedServersOnDesktop', true

    # Info Viewer Fields
    write 'FXInfoPanesExpanded', {
      'General' => true,
      'MetaData' => false,
      'Name' => true,
      'OpenWith' => true,
      'Comments' => false,
      'Preview' => false,
      'Privileges' => true,
    }

    # Show Finder sidebar.
    write 'ShowSidebar', true
    write 'ShowStatusBar', true
    write 'ShowPreviewPane', true

    write 'SidebarZoneOrder1', %w[
      icloud
      favorites
      devices
      tags
    ]

    write 'ShowRecentTags', true
    write 'SidebarDevicesSectionDisclosedState', true
    write 'SidebarPlacesSectionDisclosedState', true
    write 'SidebariCloudDriveSectionDisclosedState', true
    write 'SidebarShowingSignedIntoiCloud', true
    write 'SidebarShowingiCloudDesktop', true
    write 'FXICloudDriveEnabled', true
    write 'FXICloudDriveDesktop', true
    write 'FXICloudDriveDocuments', true

    # Desktop View Settings
    write 'DesktopViewSettings', {
      'IconViewSettings' => {
        'arrangeBy' => 'name',
        'backgroundColorBlue' => 1.0,
        'backgroundColorGreen' => 1.0,
        'backgroundColorRed' => 1.0,
        'backgroundType' => 0,
        'gridOffsetX' => 0,
        'gridOffsetY' => 0,
        'gridSpacing' => 100,
        'iconSize' => 64,
        'labelOnBottom' => false,
        'showIconPreview' => true,
        'showItemInfo' => true,
        'textSize' => 12,
        'viewOptionsVersion' => 1,
      },
    }

    killall 'cfprefsd'

    # Disable warning when changing a extension.
    write 'FXEnableExtensionChangeWarning', false

    # Disable warning when emptying trash.
    write 'WarnOnEmptyTrash', false

    # Search current directory by default.
    write 'FXDefaultSearchScope', 'SCcf'

    # Use column view in all Finder windows by default.
    write 'FXPreferredViewStyle', 'clmv'

    # Open new Finder windows with User directory.
    write 'NewWindowTarget', 'PfHm'
  end

  # Disable the “Are you sure you want to open this application?” dialog.
  defaults 'com.apple.LaunchServices' do
    write 'LSQuarantine', false
  end

  # Disable Gatekeeper.
  command sudo, '/usr/sbin/spctl', '--master-disable'

  # Show drives and servers in sidebar.
  defaults 'com.apple.sidebarlists' do
    write 'systemitems', {
      'ShowEjectables' => true,
      'ShowHardDisks' => true,
      'ShowRemovable' => true,
      'ShowServers' => true,
    }

    write 'networkbrowser', {
      'CustomListProperties' => {
        'backToMyMacEnabled' => true,
        'bonjourEnabled' => true,
        'connectedEnabled' => true,
      },
    }

    killall 'cfprefsd'
  end

  # Enable spring-loading directories and decrease default delay.
  defaults 'NSGlobalDomain' do
    write 'com.apple.springing.enabled', true
    write 'com.apple.springing.delay', 0.2
  end

  # Disable Disk Image verification.
  defaults 'com.apple.frameworks.diskimages' do
    write 'skip-verify', true
    write 'skip-verify-locked', true
    write 'skip-verify-remote', true
  end

  killall 'cfprefsd'

  # Set default apps.
  command 'duti', '-s', 'at.eggerapps.tabletool', 'csv', 'all'
  command 'duti', '-s', 'com.macromates.TextMate', 'rb', 'all'
  command 'duti', '-s', 'com.macromates.TextMate', 'rake', 'all'
  command 'duti', '-s', 'com.macromates.TextMate', 'json', 'all'
  command 'duti', '-s', 'com.macromates.TextMate', 'yml', 'all'
  command 'duti', '-s', 'com.uranusjr.macdown', 'md', 'all'

  # Add sidebar items.
  command sudo, 'mysides', 'remove', 'all'
  command sudo, 'mysides', 'add', 'Applications', 'file:///Applications/'
  # command sudo, 'mysides', 'add', 'iCloud', 'x-apple-finder:icloud'
  command sudo, 'mysides', 'add', 'Home', "file://#{File.expand_path('~/')}"
  # command sudo, 'mysides', 'add', 'Desktop', "file://#{File.expand_path('~/Desktop/')}"
  # command sudo, 'mysides', 'add', 'Documents', "file://#{File.expand_path('~/Documents/')}"
  command sudo, 'mysides', 'add', 'Downloads', "file://#{File.expand_path('~/Downloads/')}"
  command sudo, 'mysides', 'add', 'Music', "file://#{File.expand_path('~/Music/')}"
  command sudo, 'mysides', 'add', 'Pictures', "file://#{File.expand_path('~/Pictures/')}"
  command sudo, 'mysides', 'add', 'Movies', "file://#{File.expand_path('~/Movies/')}"
  command sudo, 'mysides', 'add', 'Recently used',
          'file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch/'
end
