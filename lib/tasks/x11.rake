task :x11 do
  defaults 'org.macosforge.xquartz.X11' do
    write 'no_auth', false
    write 'nolisten_tcp', false
  end
end
