# frozen_string_literal: true

require 'login_item'
require 'defaults'

task :fluor => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring Fluor …' }

  defaults 'com.pyrolyse.Fluor' do
    write 'SUAutomaticallyUpdate', false
    write 'SUEnableAutomaticChecks', false

    bundle_id = 'com.TexelRaptor.Parkitect'
    path = path_by_bundle_id(bundle_id)

    write 'AppRules', [
      {
        'behaviour' => 2,
        'id' => bundle_id,
        'path' => path,
      }
    ]
  end

  puts ANSI.blue { 'Adding Fluor to login items …' }
  add_login_item 'com.pyrolyse.Fluor', hidden: true
end
