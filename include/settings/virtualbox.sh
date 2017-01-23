defaults_virtualbox() {

  # VirtualBox VM Directory
  if type VBoxManage &>/dev/null; then
    VBoxManage setproperty machinefolder ~/Library/Caches/VirtualBox/Virtual\ Machines/
  fi

}
