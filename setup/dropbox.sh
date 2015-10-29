#!/bin/sh


# Check if Dropbox has finishes syncing.

open -gja 'Dropbox'
cecho 'Waiting for Dropbox to finish syncing …' $blue
until osascript -e 'tell application "System Events" to tell application process "Dropbox" to get help of menu bar item 1 of menu bar 2' | grep --quiet -E 'Aktualisiert|Up to date'; do sleep 5; done


# Also move hidden files.

shopt -s dotglob


# Create Symlinks for Dropbox folders.

link_to_dropbox() {

  local dropbox_dir=$(sed -E 's/.*\"path\":\ *\"(.*)\",.*/\1/' '~/.dropbox/info.json' 2>/dev/null)
  [[ -n "${dropbox_dir}" ]] || return 1

  dropbox_dir=$dropbox_dir/Sync/~

  if [[ -z $2 ]]; then
    dropbox_dir="$dropbox_dir/$1"
    local_dir="$1"
  else
    dropbox_dir="$dropbox_dir/$1"
    local_dir="$2"
  fi

  local_dir="~/$local_dir"

  eval dropbox_dir_full=$dropbox_dir
  eval local_dir_full=$local_dir

  mkdir -p "$dropbox_dir_full"; mkdir -p "$local_dir_full"

  if [[ -L "$dropbox_dir_full" ]]; then
    cecho "$local_dir already linked to Dropbox." $green
  else
    cecho "Linking $local_dir to $dropbox_dir …" $blue
    killall Dropbox

    if mv -f "$dropbox_dir_full"/* "$local_dir_full"/ && rmdir "$dropbox_dir_full" && ln -sfn "$local_dir_full" "$dropbox_dir_full"; then
      open -gja Dropbox
    else
      cecho "Error linking $local_dir to $dropbox_dir." $red
    fi
  fi

}


link_to_dropbox 'Desktop'

link_to_dropbox 'Library/Fonts'

link_to_dropbox 'Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks'

link_to_dropbox 'Documents/Backups'
link_to_dropbox 'Documents/Cinquecento'
link_to_dropbox 'Documents/Entwicklung'
link_to_dropbox 'Documents/Fonts'
link_to_dropbox 'Documents/Notizen'
link_to_dropbox 'Documents/Projekte'
link_to_dropbox 'Documents/Scans'
link_to_dropbox 'Documents/SketchUp'
link_to_dropbox 'Documents/Sonstiges'
link_to_dropbox 'Documents/Uni'


# Relink “mackup”.

if hash mackup; then

  cecho "Relinking “mackup” …" $blue

  eval mackupcfg=~/.mackup.cfg
  rm   $mackupcfg &>/dev/null
  echo '[storage]' > $mackupcfg
  echo 'engine = dropbox' >> $mackupcfg
  echo 'directory = Sync/~' >> $mackupcfg

  yes | mackup restore &>/dev/null
  yes | mackup restore
  yes | mackup backup || echo \r
fi


# Local Scripts

eval local_dotfiles='~/Library/Scripts/local-dotfiles.sh'
if [ -f "$local_dotfiles" ]; then
  cecho "Running local Scripts …" $blue
  sh "$local_dotfiles"
fi
