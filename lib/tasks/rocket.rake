require 'defaults'

task :rocket do
  puts ANSI.blue { 'Configuring Rocket …' }

  defaults 'net.matthewpalmer.Rocket' do
    write 'launch-at-login', true
    write 'preferred-skin-tone', 2
  end

  puts ANSI.blue { 'Adding Rocket to login items …' }
  add_login_item 'net.matthewpalmer.Rocket', hidden: true
end
