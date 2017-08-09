defaults_vagrant() {

  if which vagrant &>/dev/null; then
    if ! vagrant plugin list | /usr/bin/grep -q vagrant-parallels; then
      vagrant plugin install vagrant-parallels
    fi

    if ! vagrant plugin list | /usr/bin/grep -q vagrant-hostsupdater; then
      vagrant plugin install vagrant-hostsupdater
    fi
  fi

  {
    echo '# Allow passwordless startup of Vagrant with vagrant-hostsupdater.';
    echo 'Cmnd_Alias VAGRANT_HOSTS_ADD = /bin/sh -c echo "*" >> /etc/hosts';
    echo 'Cmnd_Alias VAGRANT_HOSTS_REMOVE = /usr/bin/sed -i -e /*/ d /etc/hosts';
    echo '%admin ALL=(root) NOPASSWD: VAGRANT_HOSTS_ADD, VAGRANT_HOSTS_REMOVE';
  } | sudo -E -- /usr/bin/tee /etc/sudoers.d/vagrant_hostsupdater

}
