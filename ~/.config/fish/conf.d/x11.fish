# This file was created automatically, do not edit it directly.

if status --is-interactive; and test -z "$SSH_CLIENT"; and test -z "$SSH_TTY"; and test -z "$DISPLAY"
  set -x DISPLAY :0
end
