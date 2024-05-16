# frozen_string_literal: true

require 'add_line_to_file'
require 'ansi'
require 'command'
require 'macos'

task :git => [:'git:config', :'git:commands', :'git:aliases']

namespace :git do
  desc 'Set up Git Configuration'
  task :config => :commands do
    git_config_dir = File.expand_path('~/.config/git')
    git_config = "#{git_config_dir}/config"
    git_attributes = "#{git_config_dir}/attributes"

    FileUtils.mkdir_p git_config_dir
    FileUtils.touch git_config

    command 'git', 'config', '--global', 'user.name', 'Markus Reiter'
    command 'git', 'config', '--global', 'user.email', 'me@reitermark.us'

    command 'git', 'config', '--global', 'credential.helper', 'osxkeychain' if macos?

    command 'git', 'config', '--global', 'color.ui', 'auto'

    command 'git', 'config', '--global', 'rerere.enabled', 'true'
    command 'git', 'config', '--global', 'rerere.autoupdate', 'true'

    command 'git', 'config', '--global', 'diff.algorithm', 'histogram'

    command 'git', 'config', '--global', 'diff.plist.textconv', 'plutil -convert xml1 -o -'
    command 'git', 'config', '--global', 'diff.plist.binary', 'false'
    add_line_to_file git_attributes, '*.plist diff=plist'

    command 'git', 'config', '--global', 'diff.strings.textconv', 'iconv -f utf-16 -t utf-8'
    command 'git', 'config', '--global', 'diff.strings.binary', 'false'
    add_line_to_file git_attributes, '*.strings utf16 diff=strings'

    command 'git', 'config', '--global', 'diff.sops.textconv',
            'sh -c "echo \'-----BEGIN SOPS ENCRYPTED CONTENT-----\' && ' \
            'sops -d \\"${@}\\" && ' \
            'echo \'-----END SOPS ENCRYPTED CONTENT-----\'"'
    command 'git', 'config', '--global', 'diff.sops.binary', 'false'
    add_line_to_file git_attributes, '*.enc.yml diff=sops'

    # GPG
    command 'git', 'config', '--global', 'user.signingKey', 'Markus Reiter <me@reitermark.us>'
    command 'git', 'config', '--global', 'commit.gpgSign', 'true'

    git_gpg = which 'git-gpg'
    raise if git_gpg.nil?

    command 'git', 'config', '--global', 'gpg.program', git_gpg

    # Automatically set remote branch on `push`.
    command 'git', 'config', '--global', 'push.autoSetupRemote', 'true'

    # Always use SSH URLs for pushing to GitHub and for pulling from private repositories.
    command 'git', 'config', '--global', 'url.ssh://git@github.com/editiontirol/.insteadof', 'https://github.com/editiontirol/'
    command 'git', 'config', '--global', 'url.ssh://git@github.com/oc-reith/.insteadof', 'https://github.com/oc-reith/'
    command 'git', 'config', '--global', 'url.ssh://git@github.com/.pushInsteadOf', 'https://github.com/'
    command 'git', 'config', '--global', 'url.ssh://git@github.com/reitermarkus/.insteadOf', 'https://github.com/reitermarkus/'
    command 'git', 'config', '--global', 'url.ssh://git@git.uibk.ac.at/.insteadOf', 'https://git.uibk.ac.at/'

    # Don't use SSH for Homebrew tap.
    command 'git', 'config', '--global', 'url.https://github.com/reitermarkus/homebrew-tap.insteadOf', 'https://github.com/reitermarkus/homebrew-tap'

    command 'git', 'config', '--global', 'instaweb.httpd', 'webrick'
    command 'git', 'config', '--global', 'instaweb.browser', 'open'

    unless linux?
      command 'git', 'config', '--global', 'mergetool.araxis.path', 'araxiscompare'
      command 'git', 'config', '--global', 'merge.tool', 'araxis'

      command 'git', 'config', '--global', 'difftool.araxis.path', 'araxiscompare'
      command 'git', 'config', '--global', 'diff.tool', 'araxis'
    end

    git_config_private = "#{git_config_dir}/config-private"
    command 'git', 'config', '--global', 'include.path', git_config_private
    FileUtils.touch git_config_private
  end

  desc 'Install Git Commands'
  task :commands => :gpg do
    git_bin = '~/.config/git/bin'
    git_bin_path = Pathname(git_bin).expand_path
    git_bin_path.mkpath
    ENV['PATH'] = "#{git_bin_path}:#{ENV.fetch('PATH')}"
    add_line_to_file fish_environment, "mkdir -p #{git_bin}; and set -x fish_user_paths #{git_bin} $fish_user_paths"
    add_line_to_file bash_environment, "mkdir -p #{git_bin} && export PATH=#{git_bin}:\"$PATH\""

    gpg = which 'gpg'
    raise if gpg.nil?

    git_gpg = git_bin_path.join('git-gpg')
    git_gpg.write <<~SH
      #!/usr/bin/env bash

      export GNUPGHOME=#{ENV.fetch('GNUPGHOME').shellescape}
      exec #{gpg.shellescape} "${@}"
    SH
    chmod '+x', git_gpg
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

    # Automatically update submodules according to `git checkout`.
    command 'git', 'config', '--global', 'submodule.recurse', 'true'

    command 'git', 'config', '--global', 'alias.s', 'add -p'
    command 'git', 'config', '--global', 'alias.u', 'reset -p'
    command 'git', 'config', '--global', 'alias.d', 'checkout -p'

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
