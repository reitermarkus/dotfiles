has_enough_space() {
  test "$(df -g / | awk '{ if(NR==2) print $4 }')" -ge 200
}
