

# Relocate Microsoft folder.

if [ -d ~/Documents/Microsoft*/ ]; then
  cecho 'Moving Microsoft folder to Library …' $blue
  mv ~/Documents/Microsoft*/ ~/Library/Preferences/
fi


# Remove Temporary Git Repo

cecho 'Removing “dotfiles” Repository …' $blue
rm -rf $git_dir
