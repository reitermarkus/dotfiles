defaults_git() {
  local gitattributes=~/.config/git/attributes
  /usr/bin/touch ~/.config/git/config

  git config --global user.name 'Markus Reiter'
  git config --global user.email 'me@reitermark.us'

  git config --global credential.helper osxkeychain

  git config --global color.ui auto

  git config --global rerere.enabled true

  git config --global diff.plist.textconv 'plutil -convert xml1 -o -'
  git config --global diff.plist.binary false
  add_line_to_file "${gitattributes}" '*.plist diff=plist'

  git config --global diff.strings.textconv 'iconv -f utf-16 -t utf-8'
  git config --global diff.strings.binary false
  add_line_to_file "${gitattributes}" '*.strings diff=strings'

  # Change last n commits.
  git config --global alias.change '! change() { git rebase -i "HEAD~${1:-1}"; }; change'
}
