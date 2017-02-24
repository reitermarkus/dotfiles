add_app_to_tcc() {

  # Add App to Accessibility Database.
  if is_app_installed "${1}"; then
    for bundle_id in "${@}"; do
      if test -z "$(/usr/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
                   "SELECT * FROM access WHERE client = '${bundle_id}' AND allowed = 1")"; then
        echo -y "Please enable accessibility access for '${bundle_id}' manually."
      fi
    done
  fi

}
