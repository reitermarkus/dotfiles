defaults_git() {
  local gitattributes=~/.config/git/attributes
  /usr/bin/touch ~/.config/git/config

  git config --global user.name 'Markus Reiter'
  git config --global user.email 'me@reitermark.us'

  git config --global credential.helper osxkeychain

  git config --global color.ui auto

  git config --global rerere.enabled true
  git config --global rerere.autoupdate true

  git config --global diff.algorithm histogram

  git config --global diff.plist.textconv 'plutil -convert xml1 -o -'
  git config --global diff.plist.binary false
  add_line_to_file "${gitattributes}" '*.plist diff=plist'

  git config --global diff.strings.textconv 'iconv -f utf-16 -t utf-8'
  git config --global diff.strings.binary false
  add_line_to_file "${gitattributes}" '*.strings diff=strings'

  # Always use SSH URLs for pushing to GitHub and for pulling from private repositories.
  git config --global url.ssh://git@github.com/.pushInsteadOf https://github.com/
  git config --global url.ssh://git@github.com/reitermarkus/.insteadOf https://github.com/reitermarkus/

  # Show all aliases.
  git config --global alias.aliases 'config --get-regexp ^alias\.'

  # Change last n commits.
  git config --global alias.change '! f() { git rebase -i "HEAD~${1:-1}" --autostash; }; f'

  # Output nice log graph.
  git config --global alias.tree 'log --graph --oneline --decorate --all'

  # Only diff words instead of lines.
  git config --global alias.wdiff 'diff --word-diff=color'

  # Amend all changes to the last commit.
  git config --global alias.amend 'commit --amend --all --no-edit'

  git config --global alias.s 'add -p'
  git config --global alias.u 'reset -p'
  git config --global alias.d 'checkout -p'

  git config --global alias.master '! f() { git fetch ${1:-origin} master && git rebase --autostash ${1:-origin}/master; }; f'

  git config --global alias.sync '! f() { git pull --rebase ${@} && git push ${@}; }; f'

  git config --global alias.new 'checkout -b'
  git config --global alias.shove 'push --force-with-lease'

  git config --global alias.cp 'cherry-pick'
  git config --global alias.st 'status -s'
  git config --global alias.cl 'clone'
  git config --global alias.ci 'commit'
  git config --global alias.co 'checkout'
  git config --global alias.br 'branch '
  git config --global alias.dc 'diff --cached'

  git config --global alias.r 'reset'
  git config --global alias.r1 'reset HEAD^'
  git config --global alias.r2 'reset HEAD^^'
  git config --global alias.rh 'reset --hard'
  git config --global alias.rh1 'reset HEAD^ --hard'
  git config --global alias.rh2 'reset HEAD^^ --hard'

  git config --global alias.sl 'stash list'
  git config --global alias.sa 'stash apply'
  git config --global alias.ss 'stash save'

}
