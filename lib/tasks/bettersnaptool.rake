task :bettersnaptool do
  add_login_item 'com.hegenberg.BetterSnapTool', hidden: true

  defaults 'com.hegenberg.BetterSnapTool' do
    write 'BSTCornerRoundness', 4.0
    write 'BSTDuplicateMenubarMenu', false
    write 'BSTPreventTopMissionControl', false
    write 'centernext_m', false
    write 'cycle_lrm', false
    write 'cycle_quarters', false
    write 'greenButton', 100
    write 'launchOnStartup', true
    write 'maxnext_m', false
    write 'next_m', false
    write 'previewAnimated', false
    write 'previewBorderWidth', 0.0
    write 'showMenubarIcon', false
    write 'previewWindowBackgroundColor', color(0, 0, 0, 0.1)
  end

  capture '/usr/bin/killall', 'cfprefsd'
end
