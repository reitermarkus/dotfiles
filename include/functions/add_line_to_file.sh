add_line_to_file() {
  local config="${1}"
  local line="${2}"

  if ! /usr/bin/grep --quiet "\b${line}\b" "${config}"; then
    echo "${line}" >> "${config}"
  fi
}
