is_laptop() {
  ioreg -c IOPlatformExpertDevice -r -d 1 | grep '"model"' | grep --quiet 'Book'
}


is_desktop() {
  ! is_laptop
}

