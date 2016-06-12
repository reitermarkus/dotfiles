has_enough_space() {
  test "$(/bin/df -g / | /usr/bin/awk '{ if(NR==2) print $4 }')" -ge 200
}
