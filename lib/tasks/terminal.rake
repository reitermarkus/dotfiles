require 'defaults'

task :terminal do
  defaults 'com.apple.Terminal' do
    write 'HasMigratedDefaults', true
    write 'SecureKeyboardEntry', true
    write 'Shell', ''
    write 'CopyAttributesProfile', ''

    write 'Default Window Settings', 'Solarized Light'
    write 'Startup Window Settings', 'Solarized Light'
    write 'Window Settings', {
      'Solarized Light' => {
        'name' => "Solarized Light",
        'TerminalType' => "xterm-256color",
        'CommandString' => "",
        'BackgroundColor' => color(252, 244, 220, 0.9),
        'CursorColor' => color(147, 161, 161),
        'SelectionColor' => color(7, 54, 66),
        'Font' => font('MesloLGSNerdFontComplete-Regular'),
        'TextColor' => color(147, 161, 161),
        'TextBoldColor' => color(88, 110, 117),
        'ANSIBlackColor' => color(0, 43, 54),
        'ANSIBlueColor' => color(38, 139, 210),
        'ANSIBrightBlackColor' => color(7, 54, 66),
        'ANSIBrightBlueColor' => color(131, 148, 150),
        'ANSIBrightCyanColor' => color(147, 161, 161),
        'ANSIBrightGreenColor' => color(88, 110, 117),
        'ANSIBrightMagentaColor' => color(108, 113, 196),
        'ANSIBrightRedColor' => color(203, 75, 22),
        'ANSIBrightWhiteColor' => color(253, 246, 227),
        'ANSIBrightYellowColor' => color(101, 123, 131),
        'ANSICyanColor' => color(42, 161, 152),
        'ANSIGreenColor' => color(133, 153, 0),
        'ANSIMagentaColor' => color(211, 54, 130),
        'ANSIRedColor' => color(220, 50, 47),
        'ANSIWhiteColor' => color(238, 232, 213),
        'ANSIYellowColor' => color(181, 137, 0),
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
        'BackgroundAlphaInactive' => 0.7,
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
      }
    }, add: true
  end

  capture '/usr/bin/killall', 'cfprefsd'
end
