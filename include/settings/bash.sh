defaults_bash() {

  # Bash
  local bash_bin="$(which bash)"

  # If “bash” isn't in shells file, add it.
  if ! /usr/bin/grep --quiet "${bash_bin}" /etc/shells; then
    echo "${bash_bin}" | sudo -E -- /usr/bin/tee -a /etc/shells >/dev/null
  fi

  local bash_profile="${HOME}/.bash_profile"
  local bashrc="${HOME}/.bashrc"
  local profile="${HOME}/.profile"

  /usr/bin/touch "${bash_profile}" "${bashrc}" "${profile}"

  # Import ~/.profile and ~/.bashrc into ~/.bash_profile
  add_line_to_file "${bash_profile}" 'test -f "${HOME}/.profile" && source "${HOME}/.profile"'
  add_line_to_file "${bash_profile}" 'test -f "${HOME}/.bashrc" && source "${HOME}/.bashrc"'

  # Import Bash Completion into ~/.bashrc
  add_line_to_file "${bashrc}" 'test -f /etc/bashrc && source /etc/bashrc'
  add_line_to_file "${bashrc}" 'brew ls bash-completion &>/dev/null && source "$(brew --prefix)/etc/bash_completion"'

}