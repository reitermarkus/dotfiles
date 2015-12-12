array_contains() {
  local array="${1}"
  shift

  printf '%s\0' "${array[@]}" | grep --quiet "${@}" && return 0
  return 1
}


array_contains_exactly() {
  local array="${1}"
  shift

  array_contains "${array}" "^${@}$"
}
