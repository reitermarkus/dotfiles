namespace :brew do
  task :all => [:install, :taps, :casks, :formulae]

  desc 'Install Homebrew'
  task :install do
    ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

    if which 'brew'
      system 'brew', 'update', '--force'
    else
      system '/bin/bash', '-c', '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
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

    taps = TAPS - `brew tap`.strip.split("\n")

    begin
      ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

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

    formulae = FORMULAE - `brew list`.strip.split("\n")

    begin
      ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

      download_pool = Concurrent::FixedThreadPool.new(10)
      install_pool = Concurrent::SingleThreadExecutor.new

      formulae.map { |formula|
        Concurrent::Promise
          .execute(executor: download_pool) { `brew fetch #{formula}` }
          .then(executor: install_pool) { system 'brew', 'install', formula }
      }.each(&:wait!)
    ensure
      download_pool.shutdown
      install_pool.shutdown
    end
  end

  desc "Install Casks"
  task :casks do
    CASKS = {
      'a-better-finder-rename' => [],
      'arduino-nightly' => [],
      'bibdesk' => [],
      'calibre' => [],
      'chromium' => [],
      'cyberduck' => [],
      'detexify' => [],
      'dropbox' => [],
      'docker-edge' => [],
      'epub-services' => [],
      'evernote' => [],
      'excalibur' => [],
      'fluor' => [],
      'fritzing' => [],
      'font-meslo-nerd-font' => [],
      'hazel' => [],
      'hex-fiend' => [],
      'iconvert' => ['--appdir=/Applications/iTach'],
      'ihelp' => ['--appdir=/Applications/iTach'],
      'ilearn' => ['--appdir=/Applications/iTach'],
      'itest' => ['--appdir=/Applications/iTach'],
      'insomniax' => [],
      'java' => [],
      'kaleidoscope' => [],
      'keka' => [],
      'konica-minolta-bizhub-c220-c280-c360-driver' => [],
      'launchrocket' => [],
      'latexit' => [],
      'macdown' => [],
      'mactex-no-gui' => [],
      'netspot' => [],
      'otp-auth' => [],
      'playnow' => [],
      'prizmo' => [],
      'postman' => [],
      'qlmarkdown' => [],
      'qlstephen' => [],
      'rcdefaultapp' => [],
      'rocket' => [],
      'save-hollywood' => [],
      'sequel-pro' => [],
      'sigil' => [],
      'slack' => [],
      'skim' => [],
      'db-browser-for-sqlite' => [],
      'svgcleaner' => [],
      'table-tool' => [],
      'telegram-alpha' => [],
      'tex-live-utility' => [],
      'textmate' => [],
      'textmate-crystal' => [],
      'textmate-cucumber' => [],
      'textmate-editorconfig' => [],
      'textmate-elixir' => [],
      'textmate-fish' => [],
      'textmate-onsave' => [],
      'textmate-opencl' => [],
      'textmate-rubocop' => [],
      'transmission' => [],
      'tower-beta' => [],
      # 'unicodechecker' => [],
      'vagrant' => [],
      'vagrant-manager' => [],
      'virtualbox' => [],
      'vlc-nightly' => [],
      'wineskin-winery' => [],
      'xquartz' => [],
    }

    # Ensure directories exist and have correct permissions.
    [
      '/Applications/iTach',
      '/Library/LaunchAgents',
      '/Library/LaunchDaemons',
      '/Library/Dictionaries',
      '/Library/PreferencePanes',
      '/Library/QuickLook',
      '/Library/Screen Savers',
    ].each do |dir|
      system 'sudo', '-E', '--', '/bin/mkdir', '-p', dir
      system 'sudo', '-E', '--', '/usr/sbin/chown', 'root:admin', dir
      system 'sudo', '-E', '--', '/bin/chmod', '-R', 'ug=rwx,o=rx', dir
    end

    installed_casks = `brew cask list`.strip.split("\n")
    casks = CASKS.select { |cask, _|
      next false if installed_casks.include?(cask)
      next false if ci? && cask == 'virtualbox'
      true
    }

    begin
      ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

      download_pool = Concurrent::FixedThreadPool.new(10)
      install_pool = Concurrent::SingleThreadExecutor.new

      casks.map { |cask, flags|
        Concurrent::Promise
          .execute(executor: download_pool) { `brew cask fetch #{cask}` }
          .then(executor: install_pool) { system 'brew', 'cask', 'install', cask, *flags }
      }.each(&:wait!)
    ensure
      download_pool.shutdown
      install_pool.shutdown
    end
  end
end
