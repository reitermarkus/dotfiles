task :dnsmasq => [:'brew:casks_and_formulae'] do
  brew_prefix = capture('brew', '--prefix').strip
  dnsmasq_conf = "#{brew_prefix}/etc/dnsmasq.conf"

  add_line_to_file dnsmasq_conf, 'address=/.localhost/127.0.0.1'

  command sudo, '/bin/mkdir', '-p', '/etc/resolver'

  capture sudo, '/usr/bin/tee', '/etc/resolver/localhost', input: "nameserver 127.0.0.1\n"
end
