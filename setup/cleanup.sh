#!/bin/sh


# Show “Library” folder.

if [ -d ~/Library ]; then
  chflags nohidden ~/Library
fi


# Hide “opt” folder.

if [ -d /opt ]; then
  sudo chflags hidden /opt
fi


# Relocate Microsoft folder.

if [ -d ~/Documents/Microsoft*/ ]; then
  cecho 'Moving Microsoft folder to Library …' $blue
  mv ~/Documents/Microsoft*/ ~/Library/Preferences/
fi
