defaults_fish() {

  # Fish
  if local fish_bin="$(which fish)" &>/dev/null; then

    # If “fish” isn't in shells file, add it.
    if ! /usr/bin/grep --quiet "${fish_bin}" /etc/shells; then
      echo "${fish_bin}" | sudo -E -- /usr/bin/tee -a /etc/shells >/dev/null
    fi

    # If current shell is not “fish”, change it.
    if [ "${SHELL}" != "${fish_bin}" ]; then
      echo -b "Changing to Fish Shell …"
      sudo -E -- /usr/bin/chsh -s "${fish_bin}" "${USER}" &>/dev/null
    fi

    /bin/mkdir  -p "${HOME}/.config/fish"

    /bin/mkdir  -p "${HOME}/.config/fish/conf.d"
    /bin/ln -sfn "${HOME}/.config/environment" "${HOME}/.config/fish/conf.d/__env.fish"

    # Fisherman
    fish -c \
      fisher install \
        'done' \
        'javahome' \
        'rbenv' \
        'omf/thefuck' \
        'z'
  fi

}
