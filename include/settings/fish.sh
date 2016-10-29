defaults_fish() {

  # Fish
  if local fish_bin="$(which fish)" &>/dev/null; then

    # If “fish” isn't in shells file, add it.
    if ! /usr/bin/grep --quiet "${fish_bin}" /etc/shells; then
      echo "${fish_bin}" | sudo tee -a /etc/shells &>/dev/null
    fi

    # If current shell is not “fish”, change it.
    if [ "${SHELL}" != "${fish_bin}" ]; then
      echo -b "Changing to Fish Shell …"
      sudo /usr/bin/chsh -s "${fish_bin}" "${USER}" &>/dev/null
    fi

    /bin/mkdir  -p "${HOME}/.config/fish"
  fi

}