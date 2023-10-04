# frozen_string_literal: true

task :mackup => [:'brew:casks_and_formulae'] do
  mackup_cfg = Pathname('~/.mackup.cfg').expand_path

  mackup_cfg.write <<~CFG
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
    rocket
    skim
    telegram_macos
    terminal
    textmate
    tower-2
    transmission
    xcode
  CFG

  Pathname('~/Library/Mobile Documents/com~apple~CloudDocs').expand_path.mkpath

  command 'mackup', 'restore', '--force'
  command 'mackup', 'backup', '--force'
end
