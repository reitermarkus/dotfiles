#!/bin/sh


# Relocate Microsoft folder.

if [ -d ~/Documents/Microsoft*/ ]; then
  cecho 'Moving Microsoft folder to Library …' $blue
  mv ~/Documents/Microsoft*/ ~/Library/Preferences/
fi
