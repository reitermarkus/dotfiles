#!/bin/sh


# Install Command Line Developer Tools

install_xcode_clt() {

  if xcode-select --print-path &>/dev/null; then
    echo -g 'Command Line Developer Tools are already installed.'
  else
    echo -b 'Installing Command Line Developer Tools …'

    touch '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    local CLDT=$(softwareupdate --list | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
    softwareupdate --install "${CLDT}" --verbose | grep '%'
  fi

}
