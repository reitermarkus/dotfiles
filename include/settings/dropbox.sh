defaults_dropbox() {

  # Dropbox
  add_login_item com.getdropbox.dropbox hidden

}

# Create Symlinks for Dropbox folders.

get_dropbox_dir() {
  local dropbox_dir="$(/usr/bin/head -n 2 ~/.dropbox/host.db | /usr/bin/tail -n 1 | /usr/bin/base64 -D)"

  if [ -z "${dropbox_dir}" ]; then
    echo ~/Dropbox
    return
  fi

  echo "${dropbox_dir}"
}

link_to_dropbox() {

  # Also move hidden files.
  shopt -s dotglob

  local local_dir="${HOME}/${1}"
  local dropbox_dir="$(get_dropbox_dir)/Sync/~/${1}"

  local local_dirname="$(/usr/bin/sed "s|^${HOME}|~|" <<< "${local_dir}")"
  local dropbox_dirname="$(/usr/bin/sed "s|^${HOME}|~|" <<< "${dropbox_dir}")"

  if test -L "${dropbox_dir}"; then
    echo -g "${local_dirname} already linked to Dropbox."
  else
    echo -b "Linking ${local_dirname} to ${dropbox_dirname} …"

    if ! test -d "${dropbox_dir}"; then
      /bin/rm -f "${dropbox_dir}"
    fi

    if ! test -d "${local_dir}"; then
      /bin/rm -f "${local_dir}"
    fi

    /bin/mkdir -p "${local_dir}"

    if test -d "${dropbox_dir}"; then
      /bin/rm -f "${dropbox_dir}/.DS_Store"
      /usr/bin/find "${dropbox_dir}" -depth 1 -print0 | /usr/bin/xargs -0 -I% /bin/mv -f '%' "${local_dir}/"
      /bin/rmdir "${dropbox_dir}"
    fi

    /bin/mkdir -p "$(/usr/bin/dirname "${dropbox_dir}")"
    /bin/ln -sfn "${local_dir}" "${dropbox_dir}"
  fi
}


dropbox_link_folders() {

  # Check if Dropbox has finished syncing.

  echo -b 'Setting up Dropbox symlinks …'

  /usr/bin/killall Dropbox &>/dev/null || true

  link_to_dropbox 'Desktop'

  link_to_dropbox 'Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks'
  link_to_dropbox 'Library/Fonts'
  link_to_dropbox 'Library/Desktop Pictures'
  link_to_dropbox 'Library/User Pictures'

  link_to_dropbox 'Documents/Arduino'
  link_to_dropbox 'Documents/Backups'
  link_to_dropbox 'Documents/Cinquecento'
  link_to_dropbox 'Documents/Entwicklung'
  link_to_dropbox 'Documents/Fonts'
  link_to_dropbox 'Documents/Git-Repos'
  link_to_dropbox 'Documents/Projekte'
  link_to_dropbox 'Documents/Scans'
  link_to_dropbox 'Documents/SketchUp'
  link_to_dropbox 'Documents/Sonstiges'
  link_to_dropbox 'Documents/Uni'

  /usr/bin/open -gja Dropbox

}


# Relink “mackup”.

mackup_relink() {

  if which mackup &>/dev/null; then

    echo -b "Relinking “mackup” …"

    mackup_cfg="${HOME}/.mackup.cfg"

    /bin/rm -f "${mackup_cfg}"

    /bin/cat <<EOF > "${mackup_cfg}"
[storage]
engine = dropbox
directory = Sync/~
EOF

    mackup restore --force
    mackup restore --force && mackup backup --force
  fi

}


# Local Scripts

run_local_scripts() {

  local local_dotfiles="${HOME}/Library/Scripts/local-dotfiles.sh"
  if [ -f "$local_dotfiles" ]; then
    echo -b "Running local scripts …"
    /bin/sh "$local_dotfiles"
  fi

}
