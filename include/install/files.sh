install_files() {

  echo -b 'Copying files …'

  # Use a sub-shell to avoid needing to `cd` back.
  (

    cd "${dotfiles_dir}/~"

    /usr/bin/find . \! -type d -print0 | while read -d $'\0' file; do
      file="$(/usr/bin/cut -sd / -f 2- <<< "${file}")"
      /bin/mkdir -p "$(/usr/bin/dirname "${HOME}/${file}")"
      /bin/cp -af "${file}" "${HOME}/${file}"
      echo "${file}"
    done

  )

}
