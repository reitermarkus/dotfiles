require 'defaults'

task :rocket do
  defaults 'net.matthewpalmer.Rocket' do
    write 'launch-at-login', true
    write 'preferred-skin-tone', 2
  end

  add_login_item 'net.matthewpalmer.Rocket', hidden: true
end
