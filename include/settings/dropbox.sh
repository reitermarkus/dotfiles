# Local Scripts

run_local_scripts() {

  local local_dotfiles="${HOME}/Library/Scripts/local-dotfiles.sh"
  if [ -f "$local_dotfiles" ]; then
    echo -b "Running local scripts …"
    /bin/sh "$local_dotfiles"
  fi

}
