task :finder do
  # Hide “/opt” folder.
  if File.directory?('/opt')
    command sudo, '/usr/bin/chflags', 'hidden', '/opt'
  end

  # Show “Library” folder.
  command '/usr/bin/chflags', 'nohidden', File.expand_path('~/Library')

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

    # Desktop View Settings
    write 'DesktopViewSettings', {
      'IconViewSettings' => {
        'arrangeBy' => 'name',
        'backgroundColorBlue' =>  1.0,
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
      }
    }

    capture '/usr/bin/killall', 'cfprefsd'

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

    capture '/usr/bin/killall', 'cfprefsd'
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

  capture '/usr/bin/killall', 'cfprefsd'

  # Set default apps.
  command 'duti', '-s', 'at.eggerapps.tabletool', 'csv', 'all'
  command 'duti', '-s', 'com.macromates.TextMate', 'rb', 'all'
  command 'duti', '-s', 'com.macromates.TextMate', 'rake', 'all'
  command 'duti', '-s', 'com.macromates.TextMate', 'json', 'all'
  command 'duti', '-s', 'com.macromates.TextMate', 'yml', 'all'
  command 'duti', '-s', 'com.uranusjr.macdown', 'md', 'all'
end
