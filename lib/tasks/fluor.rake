# frozen_string_literal: true

require 'login_item'
require 'defaults'

task :fluor => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring Fluor …' }

  defaults 'com.pyrolyse.Fluor' do
    write 'SUAutomaticallyUpdate', false
    write 'SUEnableAutomaticChecks', false

    games = [
      {
        id: 'com.TexelRaptor.Parkitect',
        path: '~/Library/Application Support/Steam/steamapps/common/Parkitect/Parkitect.app',
      },
      {
        id: 'cs2_osx64',
        path: '~/Library/Application Support/Steam/steamapps/common/Counter-Strike Global Offensive/csgo_osx64',
      },
    ]

    write 'AppRules', games.map { |id:, path:|
      {
        'behaviour' => 2,
        'id' => id,
        'path' => File.expand_path(path),
      }
    }
  end

  puts ANSI.blue { 'Adding Fluor to login items …' }
  add_login_item 'com.pyrolyse.Fluor', hidden: true
end
