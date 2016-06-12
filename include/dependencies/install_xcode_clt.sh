install_xcode_clt() {

  if xcode-select --print-path &>/dev/null; then
    echo -g 'Command Line Developer Tools are already installed.'
  else
    echo -b 'Installing Command Line Developer Tools …'

    /usr/bin/touch '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    local CLDT=$(softwareupdate --list | /usr/bin/grep "\*.*Command Line" | /usr/bin/head -1 | /usr/bin/sed -E 's/^[\t \*]*(.*)[\t ]*$/\1/' | tr -d '\n')
    softwareupdate --verbose --install "${CLDT}" | /usr/bin/grep '%'
  fi

}
