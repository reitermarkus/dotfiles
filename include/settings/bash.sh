defaults_bash() {

  # Bash
  local bash_bin="$(which bash)"

  # If “bash” isn't in shells file, add it.
  if ! /usr/bin/grep --quiet "${bash_bin}" /etc/shells; then
    echo "${bash_bin}" | sudo tee -a /etc/shells &>/dev/null
  fi

  local bash_profile="${HOME}/.bash_profile"
  local bashrc="${HOME}/.bashrc"
  local profile="${HOME}/.profile"

  /usr/bin/touch "${bash_profile}" "${bashrc}" "${profile}"

  add_to_config() {
    local config="${1}"
    local line="${2}"

    if ! /usr/bin/grep --quiet "${line}" "${config}"; then
      echo "${line}" >> "${config}"
    fi
  }

  # Import ~/.profile and ~/.bashrc into ~/.bash_profile
  add_to_config "${bash_profile}" 'test -f "${HOME}/.profile" && source "${HOME}/.profile"'
  add_to_config "${bash_profile}" 'test -f "${HOME}/.bashrc" && source "${HOME}/.bashrc"'

  # Import Bash Completion into ~/.bashrc
  add_to_config "${bashrc}" 'test -f /etc/bashrc && source /etc/bashrc'
  add_to_config "${bashrc}" 'brew ls bash-completion &>/dev/null && source "$(brew --prefix)/etc/bash_completion"'

}
