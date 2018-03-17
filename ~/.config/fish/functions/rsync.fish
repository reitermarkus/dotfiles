# This file was created automatically, do not edit it directly.

set -x RSYNC_EXCLUDE_LIST \
  --exclude '$RECYCLE.BIN' \
  --exclude '$Recycle.Bin' \
  --exclude '.AppleDB' \
  --exclude '.AppleDesktop' \
  --exclude '.AppleDouble' \
  --exclude '.com.apple.timemachine.supported' \
  --exclude '.dbfseventsd' \
  --exclude '.DocumentRevisions-V100*' \
  --exclude '.DS_Store' \
  --exclude '.fseventsd' \
  --exclude '.PKInstallSandboxManager' \
  --exclude '.Spotlight*' \
  --exclude '.TemporaryItems' \
  --exclude '.Trash' \
  --exclude '.Trashes' \
  --exclude '.VolumeIcon.icns' \
  --exclude 'Desktop DB' \
  --exclude 'Desktop DF' \
  --exclude 'lost+found' \
  --exclude 'Network Trash Folder' \
  --exclude 'Thumbs.db'

function rsync --wraps rsync
  command rsync $RSYNC_EXCLUDE_LIST $argv
end
