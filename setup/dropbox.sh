#!/bin/sh


# Check if Dropbox has finishes syncing.

if ! [ "`osascript -e 'tell application "System Events" to (name of processes) contains \"Dropbox\"'`" == "true" ]; then
  open -gj -a Dropbox
fi

cecho 'Waiting for Dropbox to finish syncing …' $blue
until osascript -e 'tell application "System Events" to tell application process "Dropbox" to get help of menu bar item 1 of menu bar 2' | grep Aktualisiert 2>&1>/dev/null; do :; done


# Create Symlinks for Dropbox folders.

link_to_dropbox() {

  if [ -f ~/.dropbox/info.json ]; then
    dropbox_dir=`cat ~/.dropbox/info.json | python -m json.tool | sed -n -e '/"path":/ s/^.*"\(.*\)".*/\1/p' | sed 's#/*$##'`
  else
    exit 1
  fi

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
    if cp -rf "$dropbox_dir_full/*" &>/dev/null; then
      cp -rf "$dropbox_dir_full/*" "$local_dir_full" && rm -rf "$dropbox_dir_full" && ln -sfn "$local_dir_full" "$dropbox_dir_full"
    else
      rm -rf "$dropbox_dir_full" && ln -sfn "$local_dir_full" "$dropbox_dir_full"
    fi
  fi

}


link_to_dropbox 'Desktop'

link_to_dropbox 'Library/Fonts'
link_to_dropbox 'Library/Safari/Extensions'
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
