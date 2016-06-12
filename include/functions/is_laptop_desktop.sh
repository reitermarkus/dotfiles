is_laptop() {
  /usr/sbin/ioreg -c IOPlatformExpertDevice -r -d 1 | /usr/bin/grep --quiet '"model".*Book'
}


is_desktop() {
  ! is_laptop
}

