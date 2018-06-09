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
