install_xcode_clt() {

  if /usr/bin/xcode-select --print-path &>/dev/null; then
    echo -g 'Command Line Developer Tools are already installed.'
  else
    echo -b 'Installing Command Line Developer Tools …'

    local CLDT_PLACEHOLDER='/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    /usr/bin/touch "${CLDT_PLACEHOLDER}"
    local CLDT="$(/usr/sbin/softwareupdate --list | /usr/bin/sed -E '/^.*\*\ *(Command Line Tools.*)\ *$/h;g;$!d;s//\1/')"
    /usr/sbin/softwareupdate --verbose --install "${CLDT}"
    /usr/bin/rm -f "${CLDT_PLACEHOLDER}"
  fi

}
