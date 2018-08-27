# This file was created automatically, do not edit it directly.

function eclipse
  docker-gui -v "$PWD/.eclipse-docker:/home/developer" -v "$PWD:/workspace" fgrehm/eclipse:v4.4.1
end
