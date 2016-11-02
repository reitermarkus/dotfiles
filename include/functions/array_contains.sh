array_contains() {
  local array="${1}"
  shift

  for item in ${array[@]}; do
    if [[ "${item}" =~ ${*} ]]; then
      return 0
    fi
  done

  return 1
}


array_contains_exactly() {
  local array="${1}"
  shift

  array_contains "${array[@]}" "^${*}$"
}
