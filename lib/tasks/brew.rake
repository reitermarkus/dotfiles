namespace :brew do
  task :all => [:install, :taps, :formulae, :casks]

  desc 'Install Homebrew'
  task :install do
    ENV["HOMEBREW_NO_AUTO_UPDATE"] = "1"

    if which 'brew'
      `brew update --force`
    else
      `/bin/bash -c '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'`
    end
  end

  desc "Install Taps"
  task :taps do
    TAPS = %w[
      homebrew/cask
      homebrew/cask-drivers
      homebrew/cask-fonts
      homebrew/cask-versions
      homebrew/command-not-found
      homebrew/services

      fisherman/tap

      jonof/kenutils
      reitermarkus/tap
      bfontaine/utils
    ]

    begin
      ENV["HOMEBREW_NO_AUTO_UPDATE"] = "1"

      taps = TAPS - `brew tap`.strip.split("\n")

      download_pool = Concurrent::FixedThreadPool.new(10)

      taps.map { |tap|
        Concurrent::Promise
          .execute(executor: download_pool) { `brew tap #{tap}` }
      }.each(&:wait!)
    ensure
      download_pool.shutdown
    end
  end

  desc "Install Formulae"
  task :formulae do
    FORMULAE = %w[
      bash
      bash-completion
      carthage
      ccache
      clang-format
      cmake
      crystal-lang
      dockutil
      dnsmasq
      gcc
      git
      git-lfs
      ghc
      iperf3
      node
      fish
      fisherman
      llvm
      lockscreen
      mackup
      mas
      ocaml
      ocamlbuild
      pngout
      python
      rlwrap
      rbenv
      rbenv-binstubs
      rbenv-system-ruby
      rbenv-bundler-ruby-version
      rfc
      rustup-init
      sshfs
      terminal-notifier
      thefuck
      trash
      tree
      yarn
    ]

    begin
      ENV["HOMEBREW_NO_AUTO_UPDATE"] = "1"

      formulae = FORMULAE - `brew list`.strip.split("\n")

      download_pool = Concurrent::FixedThreadPool.new(10)
      install_pool = Concurrent::SingleThreadExecutor.new

      formulae.map { |formula|
        Concurrent::Promise
          .execute(executor: download_pool) { `brew fetch #{formula}` }
          .then(executor: install_pool) { `brew install #{formula}` }
      }.each(&:wait!)
    ensure
      download_pool.shutdown
      install_pool.shutdown
    end
  end

  desc "Install Casks"
  task :casks do
    CASKS = %w[

    ]

    begin
      ENV["HOMEBREW_NO_AUTO_UPDATE"] = "1"

      casks = CASKS - `brew cask list`.strip.split("\n")

      download_pool = Concurrent::FixedThreadPool.new(10)
      install_pool = Concurrent::SingleThreadExecutor.new

      casks.map { |cask|
        Concurrent::Promise
          .execute(executor: download_pool) { `brew cask fetch #{cask}` }
          .then(executor: install_pool) { `brew cask install #{cask}` }
      }.each(&:wait!)
    ensure
      download_pool.shutdown
      install_pool.shutdown
    end
  end
end
