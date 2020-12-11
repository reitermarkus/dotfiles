# This file was created automatically, do not edit it directly.

functions -c cd __cd_ds_store
function cd
  __cd_ds_store $argv

  if test -e .DS_Store
    rm -f .DS_Store
  end
end
