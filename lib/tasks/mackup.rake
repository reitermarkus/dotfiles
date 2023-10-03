# frozen_string_literal: true

task :mackup => [:'brew:casks_and_formulae'] do
  mackup_cfg = File.expand_path('~/.mackup.cfg')

  File.write mackup_cfg, <<~CFG
    [storage]
    engine = icloud
    directory =

    [applications_to_ignore]
    ansible
    bettersnaptool
    bundler
    fish
    fisherman
    git
    hazel
    jupyter
    rubocop
    terminal
    textmate
    xcode
  CFG

  Pathname('~/Library/Mobile Documents/com~apple~CloudDocs').expand_path.mkpath

  command 'mackup', 'restore', '--force'
  command 'mackup', 'backup', '--force'
end
