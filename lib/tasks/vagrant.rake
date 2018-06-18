task :vagrant => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring Vagrant …' }

  installed_plugins = capture('vagrant', 'plugin', 'list').lines
                        .map { |line| line.split(/\s+/).first }

  [
    'vagrant-hostsupdater',
    'vagrant-parallels',
  ].each do |plugin|
    if installed_plugins.include?(plugin)
      puts ANSI.green { "Vagrant plugin “#{plugin}” is already installed." }
    else
      puts ANSI.blue { "Installing Vagrant plugin “#{plugin}” …" }
      command 'vagrant', 'plugin', 'install', plugin
    end
  end

  capture sudo, '/usr/bin/tee', '/etc/sudoers.d/vagrant_hostsupdater', input: <<~EOF
    # Allow passwordless startup of Vagrant with vagrant-hostsupdater.
    Cmnd_Alias VAGRANT_HOSTS_ADD = /bin/sh -c echo "*" >> /etc/hosts
    Cmnd_Alias VAGRANT_HOSTS_REMOVE = /usr/bin/sed -i -e /*/ d /etc/hosts
    %admin ALL=(root) NOPASSWD: VAGRANT_HOSTS_ADD, VAGRANT_HOSTS_REMOVE
  EOF
end
