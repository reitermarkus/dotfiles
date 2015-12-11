install_xcode_clt() {

  if xcode-select --print-path &>/dev/null; then
    echo -g 'Command Line Developer Tools are already installed.'
  else
    echo -b 'Installing Command Line Developer Tools …'

    touch '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    local CLDT=$(softwareupdate --list | grep "\*.*Command Line" | head -1 | sed -E 's/^[\t \*]*(.*)[\t ]*$/\1/' | tr -d '\n')
    softwareupdate --verbose --install "${CLDT}" | grep '%'
  fi

}
