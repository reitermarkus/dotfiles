defaults_dropbox() {

  # Dropbox
  add_login_item com.getdropbox.dropbox hidden

}

# Create Symlinks for Dropbox folders.

get_dropbox_dir() {
  /usr/bin/python -c "import json; print(json.load(open('$HOME/.dropbox/info.json'))['personal']['path'])"
}

link_to_dropbox() {

  # Also move hidden files.
  shopt -s dotglob

  local local_dir="${HOME}/${1}"
  local dropbox_dir="$(get_dropbox_dir)"

  if [ -d "${dropbox_dir}" ]; then

    dropbox_dir="${dropbox_dir}/Sync/~/${1}"

    if [ "${2}" != '' ]; then
      local_dir="${HOME}/${2}"
    fi

    local local_dirname="$(/usr/bin/sed "s|${HOME}|~|" <<< "${local_dir}")"
    local dropbox_dirname="$(/usr/bin/sed "s|${HOME}|~|" <<< "${dropbox_dir}")"

    if [ -L "${dropbox_dir}" ]; then
      echo -g "${local_dirname} already linked to Dropbox."
    else
      echo -b "Linking ${local_dirname} to ${dropbox_dirname} …"

      /usr/bin/killall Dropbox &>/dev/null

      /bin/rmdir "${dropbox_dir}" &>/dev/null
      /bin/rm -f "${dropbox_dir}" "${local_dir}" &>/dev/null
      /bin/mkdir  -p "${local_dir}"

      if [ -d "${dropbox_dir}" ]; then
        /bin/mv -f "${dropbox_dir}"/* "${local_dir}"/
        /bin/rmdir "${dropbox_dir}"
      fi

      if [ -d "${local_dir}" ] && [ ! -d "${dropbox_dir}" ]; then
        /bin/ln -sfn "${local_dir}" "${dropbox_dir}" || echo -r "Error linking ${local_dirname} to ${dropbox_dirname}."
      fi

    fi
  fi
}


dropbox_link_folders() {

  # Check if Dropbox has finished syncing.

  echo -b 'Waiting for Dropbox to finish syncing …'

  # Get Dropbox Localizations
  dropbox_garcon="$(/usr/bin/mdfind -onlyin / kMDItemCFBundleIdentifier==com.getdropbox.dropbox | /usr/bin/head -1)/Contents/PlugIns/garcon.appex/Contents/Resources"
  dropbox_localizations=''

  if [ -d "${dropbox_garcon}" ]; then
    for lang in "${dropbox_garcon}"/*.lproj; do
      dropbox_localizations+="$(python -c "# encoding=utf8
import sys, json; reload(sys); sys.setdefaultencoding('utf8'); print(json.loads(u'$(plutil -convert json "${lang}/garcon.strings" -o - | /usr/bin/sed "s/\'/\\\'/g")')['BadgeTooltipUptodate'])")|"
    done

    dropbox_localizations="$(/usr/bin/sed 's/|$//' <<< "${dropbox_localizations}")"
  fi

  until /usr/bin/osascript -e 'tell application "System Events" to tell application process "Dropbox" to get help of menu bar item 1 of menu bar 2' 2>/dev/null | /usr/bin/tail -1 | /usr/bin/grep --quiet -E "${dropbox_localizations}"; do

    /usr/bin/open -gja 'Dropbox'
    /bin/sleep 5
  done

  link_to_dropbox 'Desktop'

  link_to_dropbox 'Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks'
  link_to_dropbox 'Library/Fonts'
  link_to_dropbox 'Library/Desktop Pictures'
  link_to_dropbox 'Library/User Pictures'

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


  local favorites='Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.FavoriteItems.sfl'
  if [ -f "$(get_dropbox_dir)/Sync/~/${favorites}" ]; then
    /bin/rm -f "${HOME}/${favorites}"
    /bin/mv "$(get_dropbox_dir)/Sync/~/${favorites}" "${HOME}/${favorites}"
    /bin/ln -s "${HOME}/${favorites}" "$(get_dropbox_dir)/Sync/~/${favorites}"
  fi

  /usr/bin/open -gja Dropbox

}


# Relink “mackup”.

mackup_relink() {

  if type mackup &>/dev/null; then

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

  eval local_dotfiles='~/Library/Scripts/local-dotfiles.sh'
  if [ -f "$local_dotfiles" ]; then
    echo -b "Running local scripts …"
    /bin/sh "$local_dotfiles"
  fi

}
