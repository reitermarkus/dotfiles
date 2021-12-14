# frozen_string_literal: true

require 'login_item'
require 'defaults'

task :rocket => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring Rocket …' }

  defaults 'net.matthewpalmer.Rocket' do
    write 'launch-at-login', true
    write 'preferred-skin-tone', 2
  end

  puts ANSI.blue { 'Adding Rocket to login items …' }
  add_login_item 'net.matthewpalmer.Rocket', hidden: true
end
