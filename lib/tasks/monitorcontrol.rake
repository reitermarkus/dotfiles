# frozen_string_literal: true

require 'login_item'
require 'defaults'

task :monitorcontrol => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring MonitorControl …' }

  defaults 'me.guillaumeb.MonitorControl' do
    write 'appAlreadyLaunched', true
    write 'SUEnableAutomaticChecks', false
  end

  puts ANSI.blue { 'Adding MonitorControl to login items …' }
  add_login_item 'me.guillaumeb.MonitorControl', hidden: true
end
