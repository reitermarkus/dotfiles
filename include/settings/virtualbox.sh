defaults_virtualbox() {

  # VirtualBox VM Directory
  if which VBoxManage &>/dev/null; then
    VBoxManage setproperty machinefolder ~/Library/Caches/VirtualBox/Virtual\ Machines/
  fi

}
