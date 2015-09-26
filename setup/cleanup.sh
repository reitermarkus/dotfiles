#!/bin/sh


# Show “Library” folder.

chflags nohidden ~/Library


# Hide “opt” folder.

if [ -d /opt ]; then
  sudo chflags hidden /opt
fi


# Relocate Microsoft folder.

if [ -d ~/Documents/Microsoft*/ ]; then
  cecho 'Moving Microsoft folder to Library …' $blue
  mv ~/Documents/Microsoft*/ ~/Library/Preferences/
fi
