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
    write 'previewWindowBackgroundColor', StringIO.new('62706c6973743030d40102030405061516582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a307080f55246e756c6cd3090a0b0c0d0e574e5357686974655c4e53436f6c6f7253706163655624636c617373463020302e310010038002d2101112135a24636c6173736e616d655824636c6173736573574e53436f6c6f72a21214584e534f626a6563745f100f4e534b657965644172636869766572d1171854726f6f74800108111a232d32373b4148505d646b6d6f747f8890939caeb1b600000000000001010000000000000019000000000000000000000000000000b8')
  end
end
