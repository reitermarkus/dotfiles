echo() {

  # Colored “echo”.
  local color=''
  local string=''
  local bold=false

  local OPTIND
  while getopts ":rgbwcmyks" o; do
    case "${o}" in
      r) color='\033[0;31m';; # red
      g) color='\033[0;32m';; # green
      b) color='\033[0;34m';; # blue
      w) color='\033[0;37m';; # white
      c) color='\033[0;36m';; # cyan
      m) color='\033[0;35m';; # magenta
      y) color='\033[0;33m';; # yellow
      k) color='\033[0;30m';; # black
      s) bold=true;;
    esac
  done
  shift $((OPTIND-1))

  string="${*}"

  if [ ${bold} == true ]; then
    string="$(tput bold)${string}$(tput sgr0)"
  fi

  if [ "${color}" != '' ]; then
    string="${color}${string}$(tput sgr0)"
  fi


  builtin echo "${string}"

}
