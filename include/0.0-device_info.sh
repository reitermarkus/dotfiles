#!/bin/sh


# Device Type

is_laptop() {
  ioreg -c IOPlatformExpertDevice -r -d 1 | grep '"model"' | grep --quiet 'Book'
}

is_desktop() {
  ! is_laptop
}

has_enough_space() {
  test "$(df -g / | awk '{ if(NR==2) print $4 }')" -ge 200
}