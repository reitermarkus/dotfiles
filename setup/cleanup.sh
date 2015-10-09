#!/bin/sh


# Relocate Microsoft folder.

if [ -d ~/Documents/Microsoft*/ ]; then
  cecho 'Moving Microsoft folder to Library …' $blue
  mv ~/Documents/Microsoft*/ ~/Library/Preferences/
fi

# Link Textmate folder to Avian folder.

if [ ! -L ~/Library/Application\ Support/Avian ]; then
  rm -rf ~/Library/Application\ Support/Avian/
  if [ -d  ~/Library/Application\ Support/TextMate/Managed/ ]; then
    ln -s ~/Library/Application\ Support/TextMate/Managed/ ~/Library/Application\ Support/Avian
  fi
fi
