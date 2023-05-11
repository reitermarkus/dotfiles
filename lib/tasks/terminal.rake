# frozen_string_literal: true

require 'command'
require 'defaults'
require 'killall'

task :terminal do
  defaults 'com.apple.Terminal' do
    write 'HasMigratedDefaults', true
    write 'SecureKeyboardEntry', true
    write 'Shell', ''
    write 'CopyAttributesProfile', ''

    font_name = 'SauceCodeProNFM'
    font_size = 13

    base03 = color(0, 43, 54)
    base02 = color(7, 54, 66)
    base01 = color(88, 110, 117)
    base00 = color(101, 123, 131)
    base0 = color(131, 148, 150)
    base1 = color(147, 161, 161)
    base2 = color(238, 232, 213)
    base3 = color(253, 246, 227)
    yellow = color(181, 137, 0)
    orange = color(203, 75, 22)
    red = color(220, 50, 47)
    magenta = color(211, 54, 130)
    violet = color(108, 113, 196)
    blue = color(38, 139, 210)
    cyan = color(42, 161, 152)
    green = color(133, 153, 0)

    # write 'Default Window Settings', 'Solarized Light'
    # write 'Startup Window Settings', 'Solarized Light'
    write 'Window Settings', {
      'Solarized Light' => {
        'name' => 'Solarized Light',
        'TerminalType' => 'xterm-256color',
        'CommandString' => '',
        'RunCommandAsShell' => true,
        'noWarnProcesses' => [
          { 'ProcessName' => 'screen' },
          { 'ProcessName' => 'tmux' },
        ],
        'BackgroundColor' => color(253, 246, 227, 0.98),
        'CursorColor' => base1,
        'SelectionColor' => base02,
        'Font' => font(font_name, size: font_size),
        'TextColor' => base1,
        'TextBoldColor' => base01,
        'ANSIBlackColor' => base03,
        'ANSIBlueColor' => blue,
        'ANSIBrightBlackColor' => base02,
        'ANSIBrightBlueColor' => base0,
        'ANSIBrightCyanColor' => base1,
        'ANSIBrightGreenColor' => base01,
        'ANSIBrightMagentaColor' => violet,
        'ANSIBrightRedColor' => orange,
        'ANSIBrightWhiteColor' => base3,
        'ANSIBrightYellowColor' => base00,
        'ANSICyanColor' => cyan,
        'ANSIGreenColor' => green,
        'ANSIMagentaColor' => magenta,
        'ANSIRedColor' => red,
        'ANSIWhiteColor' => base2,
        'ANSIYellowColor' => yellow,
        'ProfileCurrentVersion' => 2.04,
        'rowCount' => 32,
        'columnCount' => 120,
        'FontHeightSpacing' => 1.0,
        'FontWidthSpacing' => 1.004,
        'FontAntialias' => true,
        'UseBoldFonts' => false,
        'UseBrightBold' => true,
        'BlinkText' => false,
        'DisableANSIColor' => false,
        'BackgroundBlur' => 1.0,
        'BackgroundSettingsForInactiveWindows' => true,
        'BackgroundAlphaInactive' => 0.85,
        'BackgroundBlurInactive' => true,
        'ShowActiveProcessInTitle' => true,
        'ShowActiveProcessArgumentsInTitle' => true,
        'ShowCommandKeyInTitle' => false,
        'ShowDimensionsInTitle' => false,
        'ShowRepresentedURLInTitle' => true,
        'ShowRepresentedURLPathInTitle' => false,
        'ShowShellCommandInTitle' => false,
        'ShowTTYNameInTitle' => false,
        'ShowWindowSettingsNameInTitle' => false,
        'shellExitAction' => 1,
      },
      'Solarized Dark' => {
        'name' => 'Solarized Dark',
        'TerminalType' => 'xterm-256color',
        'CommandString' => '',
        'RunCommandAsShell' => true,
        'noWarnProcesses' => [
          { 'ProcessName' => 'screen' },
          { 'ProcessName' => 'tmux' },
        ],
        'BackgroundColor' => color(0, 43, 54, 1),
        'CursorColor' => base01,
        'SelectionColor' => base02,
        'Font' => font(font_name, size: font_size),
        'TextColor' => base01,
        'TextBoldColor' => base1,
        'ANSIBlackColor' => base2,
        'ANSIBlueColor' => blue,
        'ANSIBrightBlackColor' => base3,
        'ANSIBrightBlueColor' => base00,
        'ANSIBrightCyanColor' => base01,
        'ANSIBrightGreenColor' => base1,
        'ANSIBrightMagentaColor' => violet,
        'ANSIBrightRedColor' => orange,
        'ANSIBrightWhiteColor' => base03,
        'ANSIBrightYellowColor' => base0,
        'ANSICyanColor' => cyan,
        'ANSIGreenColor' => green,
        'ANSIMagentaColor' => magenta,
        'ANSIRedColor' => red,
        'ANSIWhiteColor' => base02,
        'ANSIYellowColor' => yellow,
        'ProfileCurrentVersion' => 2.04,
        'rowCount' => 32,
        'columnCount' => 120,
        'FontHeightSpacing' => 1.0,
        'FontWidthSpacing' => 1.004,
        'FontAntialias' => true,
        'UseBoldFonts' => false,
        'UseBrightBold' => true,
        'BlinkText' => false,
        'DisableANSIColor' => false,
        'BackgroundBlur' => 1.0,
        'BackgroundSettingsForInactiveWindows' => true,
        'BackgroundAlphaInactive' => 0.85,
        'BackgroundBlurInactive' => true,
        'ShowActiveProcessInTitle' => true,
        'ShowActiveProcessArgumentsInTitle' => true,
        'ShowCommandKeyInTitle' => false,
        'ShowDimensionsInTitle' => false,
        'ShowRepresentedURLInTitle' => true,
        'ShowRepresentedURLPathInTitle' => false,
        'ShowShellCommandInTitle' => false,
        'ShowTTYNameInTitle' => false,
        'ShowWindowSettingsNameInTitle' => false,
        'shellExitAction' => 1,
      },
    }
  end

  killall 'cfprefsd'

  launchd_name = 'com.apple.TerminalInterfaceModeSwitcher'
  launchd_plist = Pathname("~/Library/LaunchAgents/#{launchd_name}.plist").expand_path

  interface_mode_switcher_path = Pathname('~/Library/Scripts/terminal_interface_mode_switcher.swift').expand_path
  interface_mode_switcher_path.dirname.mkpath
  FileUtils.cp "#{DOTFILES_DIR}/terminal_interface_mode_switcher.swift", interface_mode_switcher_path

  plist = {
    'Label' => launchd_name,
    'OnDemand' => false,
    'RunAtLoad' => true,
    'KeepAlive' => true,
    'ProgramArguments' => [
      '/usr/bin/swift', interface_mode_switcher_path.to_s,
    ],
    'StandardOutPath' => "/tmp/#{launchd_name}.txt",
    'StandardErrorPath' => "/tmp/#{launchd_name}.txt",
  }

  launchd_plist.write plist.to_plist
  command '/bin/chmod', '0644', launchd_plist.to_path

  capture '/bin/launchctl', 'load', '-w', launchd_plist.to_path
end
