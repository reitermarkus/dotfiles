defaults_environment() {

  /bin/mkdir -p "${HOME}/.config"

  local environment_file="${HOME}/.config/environment"

  echo "# This file was created automatically, do not edit it directly.\n\n" > "${environment_file}"
  /bin/cat "${dotfiles_dir}/include/environment.sh" >> "${environment_file}"

}
