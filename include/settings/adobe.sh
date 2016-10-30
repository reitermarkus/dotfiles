defaults_adobe() {

  # Remove Adobe Patch Files.
  /bin/rm -rf /Applications/Adobe/AdobePatchFiles

  if [ -d /Applications/Adobe ];then
    /bin/rmdir /Applications/Adobe
  fi

}
