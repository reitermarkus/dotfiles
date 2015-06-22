# Show “Library” folder.
if [ -d ~/Library ]; then
  chflags nohidden ~/Library
fi


# Hide “opt” folder.
if [ -d /opt ]; then
  sudo chflags hidden /opt
fi


# Delete Microsoft Office Installer.
if [ -f /opt/homebrew-cask/Caskroom/microsoft-office/latest/Office\ Installer.pkg ]; then
  rm /opt/homebrew-cask/Caskroom/microsoft-office/latest/Office\ Installer.pkg
fi


# Relocate Microsoft folder.
if [ -d ~/Documents/Microsoft*/ ]; then
  cecho 'Moving Microsoft folder to Library …' $blue
  mv ~/Documents/Microsoft*/ ~/Library/Preferences/
fi
