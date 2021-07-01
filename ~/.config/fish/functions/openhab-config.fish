# This file was created automatically, do not edit it directly.

function openhab-config
  set -l share '/tmp/smb/shares/server.local/Macintosh'
  set -l pass (security find-internet-password -wa "$USER" -s Server._smb._tcp.local)

  mkdir -p "$share"
  mount -t smbfs "//$USER:$pass@server.local/Macintosh" "$share" 2>&-

  cd  "$share/usr/local/etc/openhab/"; and \
  edit "$share/usr/local/etc/openhab/"
end
