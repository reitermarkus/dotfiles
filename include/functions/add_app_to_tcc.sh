add_app_to_tcc() {

  # Add App to Accessibility Database.
  if is_app_installed "${1}"; then
    for bundle_id in "${@}"; do
      sudo /usr/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
      "insert or replace into access values('kTCCServiceAccessibility','${bundle_id}',0,1,1,NULL,NULL);"
    done
  fi

}
