require 'add_line_to_file'
require 'ansi'
require 'command'

task :git => [:'git:config', :'git:commands', :'git:aliases']

namespace :git do
  desc 'Set up Git Configuration'
  task :config do
    git_config_dir = File.expand_path('~/.config/git')
    git_config = "#{git_config_dir}/config"
    git_attributes = "#{git_config_dir}/attributes"

    FileUtils.mkdir_p git_config_dir
    FileUtils.touch git_config

    command 'git', 'config', '--global', 'user.name', 'Markus Reiter'
    command 'git', 'config', '--global', 'user.email', 'me@reitermark.us'

    command 'git', 'config', '--global', 'credential.helper', 'osxkeychain'

    command 'git', 'config', '--global', 'color.ui', 'auto'

    command 'git', 'config', '--global', 'rerere.enabled', 'true'
    command 'git', 'config', '--global', 'rerere.autoupdate', 'true'

    command 'git', 'config', '--global', 'diff.algorithm', 'histogram'

    command 'git', 'config', '--global', 'diff.plist.textconv', 'plutil -convert xml1 -o -'
    command 'git', 'config', '--global', 'diff.plist.binary', 'false'
    add_line_to_file git_attributes, '*.plist diff=plist'

    command 'git', 'config', '--global', 'diff.strings.textconv', 'iconv -f utf-16 -t utf-8'
    command 'git', 'config', '--global', 'diff.strings.binary', 'false'
    add_line_to_file git_attributes, '*.strings diff=strings'

    # Always use SSH URLs for pushing to GitHub and for pulling from private repositories.
    command 'git', 'config', '--global', 'url.ssh://git@github.com/.pushInsteadOf', 'https://github.com/'
    command 'git', 'config', '--global', 'url.ssh://git@github.com/reitermarkus/.insteadOf', 'https://github.com/reitermarkus/'

    # Don't use SSH for Homebrew tap.
    command 'git', 'config', '--global', 'url.https://github.com/reitermarkus/homebrew-tap.insteadOf', 'https://github.com/reitermarkus/homebrew-tap'

    command 'git', 'config', '--global', 'instaweb.httpd', 'webrick'
    command 'git', 'config', '--global', 'instaweb.browser', 'open'
  end

  desc 'Install Git Commands'
  task :commands do
    bin = '~/.config/git/commands'
    add_line_to_file fish_environment, "mkdir -p #{bin}; and set -x fish_user_paths #{bin} $fish_user_paths"
    add_line_to_file bash_environment, "mkdir -p #{bin} && export PATH=#{bin}:\"$PATH\""
  end

  desc 'Install Git Aliases'
  task :aliases do
    puts ANSI.blue { 'Installing Git aliases …' }

    # Show all aliases.
    command 'git', 'config', '--global', 'alias.aliases', 'config --get-regexp ^alias\.'

    # Change last n commits.
    command 'git', 'config', '--global', 'alias.change', '! f() { git rebase -i "HEAD~${1:-1}" --autostash; }; f'

    # Output nice log graph.
    command 'git', 'config', '--global', 'alias.tree', 'log --graph --oneline --decorate --all'

    # Only diff words instead of lines.
    command 'git', 'config', '--global', 'alias.wdiff', 'diff --word-diff=color'

    # Amend all changes to the last commit.
    command 'git', 'config', '--global', 'alias.amend', 'commit --amend --all --no-edit'

    command 'git', 'config', '--global', 'alias.s', 'add -p'
    command 'git', 'config', '--global', 'alias.u', 'reset -p'
    command 'git', 'config', '--global', 'alias.d', 'checkout -p'

    command 'git', 'config', '--global', 'alias.master', '! f() { git fetch ${1:-origin} master && git rebase --autostash ${1:-origin}/master; }; f'

    command 'git', 'config', '--global', 'alias.sync', '! f() { git pull --rebase ${@} && git push ${@}; }; f'

    command 'git', 'config', '--global', 'alias.new', 'checkout -b'
    command 'git', 'config', '--global', 'alias.shove', 'push --force-with-lease'

    command 'git', 'config', '--global', 'alias.cp', 'cherry-pick'
    command 'git', 'config', '--global', 'alias.st', 'status -s'
    command 'git', 'config', '--global', 'alias.cl', 'clone'
    command 'git', 'config', '--global', 'alias.ci', 'commit'
    command 'git', 'config', '--global', 'alias.co', 'checkout'
    command 'git', 'config', '--global', 'alias.br', 'branch '
    command 'git', 'config', '--global', 'alias.dc', 'diff --cached'

    command 'git', 'config', '--global', 'alias.r', 'reset'
    command 'git', 'config', '--global', 'alias.r1', 'reset HEAD^'
    command 'git', 'config', '--global', 'alias.r2', 'reset HEAD^^'
    command 'git', 'config', '--global', 'alias.rh', 'reset --hard'
    command 'git', 'config', '--global', 'alias.rh1', 'reset HEAD^ --hard'
    command 'git', 'config', '--global', 'alias.rh2', 'reset HEAD^^ --hard'

    command 'git', 'config', '--global', 'alias.sl', 'stash list'
    command 'git', 'config', '--global', 'alias.sa', 'stash apply'
    command 'git', 'config', '--global', 'alias.ss', 'stash save'
  end
end
