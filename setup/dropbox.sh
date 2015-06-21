# Create Symlinks for Dropbox folders.

link_to_dropbox() {

  user_dir='~'
  dropbox_dir=Dropbox

  if [[ -z $2 ]]; then
    dropbox_dir="$dropbox_dir/$1"
    local_dir="$1"
  else
    dropbox_dir="$dropbox_dir/$1"
    local_dir="$2"
  fi

  dropbox_dir="~/$dropbox_dir"
  local_dir="~/$local_dir"

  eval dropbox_dir_full=$dropbox_dir
  eval local_dir_full=$local_dir

  mkdir -p "$dropbox_dir_full"; mkdir -p "$local_dir_full"
  touch $dropbox_dir_full/.DS_Store


  if [[ -L "$dropbox_dir_full" ]]; then
    cecho "$local_dir already linked to Dropbox." $green
  else
    cecho "Linking $local_dir to $dropbox_dir …" $blue
    if cp -rf "$dropbox_dir_full/*" &>/dev/null; then
      cp -rf "$dropbox_dir_full/*" "$local_dir_full" && rm -rf "$dropbox_dir_full" && ln -sfn "$local_dir_full" "$dropbox_dir_full"
    else
      rm -rf "$dropbox_dir_full" && ln -sfn "$local_dir_full" "$dropbox_dir_full"
    fi
  fi

}

link_to_dropbox 'Desktop'

link_to_dropbox 'Library/Fonts'

link_to_dropbox 'Documents/Backups'
link_to_dropbox 'Documents/Cinquecento'
link_to_dropbox 'Documents/Entwicklung'
link_to_dropbox 'Documents/Fonts'
link_to_dropbox 'Documents/Notizen'
link_to_dropbox 'Documents/Projekte'
link_to_dropbox 'Documents/Scans'
link_to_dropbox 'Documents/SketchUp'
link_to_dropbox 'Documents/Sonstiges'


# Relink “mackup”.
if hash mackup; then
  cecho "Relinking “mackup” …" $blue
  yes | mackup restore
  yes | mackup backup || echo
fi
