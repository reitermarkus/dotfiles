#!/bin/sh


# Change shell to “fish”.

install_fish_shell() {

  local fish_bin

  if fish_bin="$(which fish)"; then

    # Check if “fish” is in shells file.
    if ! grep --quiet "${fish_bin}" /etc/shells; then
      echo "${fish_bin}" | sudo tee -a /etc/shells &>/dev/null
    fi

    # If current shell is not “fish”, change it.
    if [ "${SHELL}" != "${fish_bin}" ]; then
      echo -b "Changing Shell to Fish …"
      sudo chsh -s "${fish_bin}" "${USER}" &>/dev/null
    fi

    mkdir -p "${HOME}/.config/fish/"

  fi

}
