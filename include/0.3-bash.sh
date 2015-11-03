#!/bin/sh


# Add brewed Bourne-Again Shell to shells.

install_bash_shell() {

    local bash_bin=$(which bash)

    # Check if “bash” is in shells file.
    if ! grep --quiet "${bash_bin}" /etc/shells; then
      echo "${bash_bin}" | sudo tee -a /etc/shells &>/dev/null
    fi

    touch \
      "${HOME}/.bash_profile" \
      "${HOME}/.profile" \
      "${HOME}/.bashrc" \
    ;

    # Import ~/.profile into ~/.bash_profile
    local bash_profile_source_profile='[[ -f "${HOME}/.profile" ]] && source "${HOME}/.profile"'
    if ! grep --quiet "${bash_profile_source_profile}" "${HOME}/.bash_profile"; then
      echo "${bash_profile_source_profile}" >> "${HOME}/.bash_profile"
    fi

    # Import ~/.bashrc into ~/.bash_profile
    local bash_profile_source_bashrc='[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"'
    if ! grep --quiet "${bash_profile_source_bashrc}" "${HOME}/.bash_profile"; then
      echo "${bash_profile_source_bashrc}" >> "${HOME}/.bash_profile"
    fi

    # Import Bash Completion into ~/.bashrc
    local bashrc_source_bash_completion='hash brew && [[ -f "$(brew --prefix)/etc/bash_completion" ]] && source "$(brew --prefix)/etc/bash_completion"'
    if ! grep --quiet "${bashrc_source_bash_completion}" "${HOME}/.bashrc"; then
      echo "${bashrc_source_bash_completion}" >> "${HOME}/.bashrc"
    fi

}
