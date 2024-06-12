# This file was created automatically, do not edit it directly.

function docker-gui
  open -a XQuartz

  xhost - "$hostname"

  set -x DISPLAY "$hostname:0"
  xhost + "$hostname"

  docker run -ti --rm -e DISPLAY="$DISPLAY" -v /tmp/.X11-unix:/tmp/.X11-unix $argv
end
