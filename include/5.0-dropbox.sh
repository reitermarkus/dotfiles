#!/bin/sh


# Create Symlinks for Dropbox folders.

get_dropbox_dir() {
  sed -E 's/.*\"path\":\ *\"(.*)\",.*/\1/' "${HOME}/.dropbox/info.json"
}

link_to_dropbox() {

  # Also move hidden files.
  shopt -s dotglob

  local dropbox_dir
  local local_dir

  local dropbox_dir=$(get_dropbox_dir)
  [[ -n "${dropbox_dir}" ]] || return 1

  dropbox_dir="$dropbox_dir/Sync/~/$1"

  if [[ -z "${2}" ]]; then
    local_dir="~/${1}"
  else
    local_dir="~/${2}"
  fi

  eval dropbox_dir_full=$dropbox_dir
  eval local_dir_full=$local_dir

  if [[ -L "$dropbox_dir_full" ]]; then
    echo -g "${local_dir} already linked to Dropbox."
  else
    echo -b "Linking ${local_dir} to ${dropbox_dir} …"

    killall Dropbox &>/dev/null

    rmdir "$dropbox_dir_full" "$local_dir_full" &>/dev/null
    rm -f "$local_dir_full"

    if [ ! -d "$local_dir_full" ] && [ -d "$dropbox_dir_full" ]; then
      mv -f "$dropbox_dir_full" "$local_dir_full"
    elif [ -d "$local_dir_full" ] && [ -d "$dropbox_dir_full" ]; then
      mv -f "$dropbox_dir_full"/* "$local_dir_full"/
      rmdir "$dropbox_dir_full"
    elif [ ! -d "$local_dir_full" ] && [ ! -d "$dropbox_dir_full" ]; then
      mkdir -p "$local_dir_full"
    fi

    if [ -d "$local_dir_full" ] && [ ! -d "$dropbox_dir_full" ]; then
      ln -sfn "$local_dir_full" "$dropbox_dir_full" || echo -r "Error linking $local_dir to $dropbox_dir."
    fi

    open -gja Dropbox

  fi

}


dropbox_link_folders() {

  # Check if Dropbox has finishes syncing.

  echo -b 'Waiting for Dropbox to finish syncing …'
  until osascript -e 'tell application "System Events" to tell application process "Dropbox" to get help of menu bar item 1 of menu bar 2' | grep --quiet -E 'Aktualisiert|Up to date'; do
    open -gja 'Dropbox'
    sleep 5
  done

  link_to_dropbox 'Desktop'

  link_to_dropbox 'Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks'
  link_to_dropbox 'Library/Fonts'

  link_to_dropbox 'Documents/Backups'
  link_to_dropbox 'Documents/Cinquecento'
  link_to_dropbox 'Documents/Entwicklung'
  link_to_dropbox 'Documents/Fonts'
  link_to_dropbox 'Documents/Git-Repos'
  link_to_dropbox 'Documents/Notizen'
  link_to_dropbox 'Documents/Projekte'
  link_to_dropbox 'Documents/Scans'
  link_to_dropbox 'Documents/SketchUp'
  link_to_dropbox 'Documents/Sonstiges'
  link_to_dropbox 'Documents/Uni'


  local favorites='Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.FavoriteItems.sfl'
  if [ -f "$(get_dropbox_dir)/Sync/~/${favorites}" ]; then
    rm -f "${HOME}/${favorites}"
    mv "$(get_dropbox_dir)/Sync/~/${favorites}" "${HOME}/${favorites}"
    ln -s "${HOME}/${favorites}" "$(get_dropbox_dir)/Sync/~/${favorites}"
  fi

}


# Relink “mackup”.

mackup_relink() {

  if hash mackup; then

    echo -b "Relinking “mackup” …"

    mackup_cfg="${HOME}/.mackup.cfg"

    rm -f "${mackup_cfg}"

    cat <<EOF > "${mackup_cfg}"
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

  eval local_dotfiles='~/Library/Scripts/local-dotfiles.sh'
  if [ -f "$local_dotfiles" ]; then
    echo -b "Running local Scripts …"
    sh "$local_dotfiles"
  fi

}
