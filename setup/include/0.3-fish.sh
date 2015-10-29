#!/bin/sh


# Change shell to “fish”.

set_default_shell_to_fish() {

  if hash fish; then

    fish_bin=$(which fish)

    # Check if “fish” is in shells file.
    if ! grep --quiet "${fish_bin}" /etc/shells; then
      echo "${fish_bin}" | sudo tee -a /etc/shells > /dev/null
    fi

    # If current shell is not “fish”, change it.
    if [[ "${SHELL}" != *"/fish" ]]; then
      sudo chsh -s "${fish_bin}" "${USER}"
    fi

    mkdir -p "${HOME}/.config/fish/"

  fi

}
