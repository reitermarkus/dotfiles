require 'ci'
require 'command'
require 'fileutils'
require 'which'

namespace :brew do
  task :all => [:install, :taps, :casks, :formulae]

  desc 'Install Homebrew'
  task :install do
    ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

    if which 'brew'
      command 'brew', 'update', '--force'
    else
      command '/usr/bin/ruby', '-e', capture('/usr/bin/curl', '-fsSL', 'https://raw.githubusercontent.com/Homebrew/install/master/install')
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

    taps = TAPS - capture('brew', 'tap').strip.split("\n")

    begin
      ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

      download_pool = Concurrent::FixedThreadPool.new(10)

      taps.map { |tap|
        Concurrent::Promise
          .execute(executor: download_pool) { command 'brew', 'tap', tap, silent: true }
      }.each(&:wait!)
    ensure
      download_pool.shutdown
    end
  end

  FORMULAE = {
    'bash' => {},
    'bash-completion' => {},
    'carthage' => {},
    'ccache' => {},
    'clang-format' => {},
    'cmake' => {},
    'crystal-lang' => {},
    'dockutil' => {},
    'dnsmasq' => {},
    'gcc' => {},
    'git' => {},
    'git-lfs' => {},
    'ghc' => {},
    'iperf3' => {},
    'node' => {},
    'fish' => {},
    'fisherman' => {},
    'llvm' => {},
    'lockscreen' => {},
    'mackup' => {},
    'mas' => {},
    'ocaml' => {},
    'ocamlbuild' => {},
    'pngout' => {},
    'python' => {},
    'rlwrap' => {},
    'rbenv' => {},
    'rbenv-binstubs' => {},
    'rbenv-system-ruby' => {},
    'rbenv-bundler-ruby-version' => {},
    'rfc' => {},
    'rustup-init' => {},
    'sshfs' => {},
    'terminal-notifier' => {},
    'thefuck' => {},
    'trash' => {},
    'tree' => {},
    'yarn' => {},
  }

  desc "Install Formulae"
  task :formulae do
    formulae = FORMULAE.keys - capture('brew', 'list').strip.split("\n")

    begin
      ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

      download_pool = Concurrent::FixedThreadPool.new(10)
      install_pool = Concurrent::SingleThreadExecutor.new

      formulae.map { |formula|
          Concurrent::Promise
          .execute(executor: download_pool) { command 'brew', 'fetch', '--deps', '--retry', formula, silent: true, tries: 3 }
          .then(executor: install_pool) { command 'brew', 'install', formula }
      }.each(&:wait!)
    ensure
      download_pool.shutdown
      install_pool.shutdown
    end
  end

  converters_dir = '/Applications/Converters.localized'
  itach_dir = '/Applications/iTach'

  CASKS = {
    'a-better-finder-rename'=> {},
    'arduino-nightly'=> {},
    'bibdesk'=> {},
    'calibre'=> {},
    'chromium'=> {},
    'cyberduck'=> {},
    'detexify'=> {},
    'dropbox'=> {},
    'docker-edge'=> {},
    'epub-services'=> {},
    'evernote'=> {},
    'excalibur'=> {},
    'fluor'=> {},
    'fritzing'=> {},
    'font-meslo-nerd-font'=> {},
    'handbrake' => { flags: ["--appdir=#{converters_dir}"] },
    'hazel'=> {},
    'hex-fiend'=> {},
    'iconvert' => { flags: ["--appdir=#{itach_dir}"] },
    'ihelp' => { flags: ["--appdir=#{itach_dir}"] },
    'ilearn' => { flags: ["--appdir=#{itach_dir}"] },
    'itest' => { flags: ["--appdir=#{itach_dir}"] },
    'image2icon' => { flags: ["--appdir=#{converters_dir}"] },
    'imageoptim' => { flags: ["--appdir=#{converters_dir}"] },
    'insomniax'=> {},
    'java'=> {},
    'kaleidoscope'=> {},
    'keka'=> {},
    'konica-minolta-bizhub-c220-c280-c360-driver'=> {},
    'launchrocket'=> {},
    'latexit'=> {},
    'macdown'=> {},
    'mactex-no-gui'=> {},
    'makemkv' => { flags: ["--appdir=#{converters_dir}"] },
    'netspot'=> {},
    'osxfuse'=> {},
    'otp-auth'=> {},
    'playnow'=> {},
    'prizmo'=> {},
    'postman'=> {},
    'qlmarkdown'=> {},
    'qlstephen'=> {},
    'rcdefaultapp'=> {},
    'rocket'=> {},
    'save-hollywood'=> {},
    'sequel-pro'=> {},
    'sigil'=> {},
    'slack'=> {},
    'skim'=> {},
    'db-browser-for-sqlite'=> {},
    'svgcleaner'=> {},
    'table-tool'=> {},
    'telegram-alpha'=> {},
    'tex-live-utility'=> {},
    'textmate'=> {},
    'textmate-crystal'=> {},
    'textmate-cucumber'=> {},
    'textmate-editorconfig'=> {},
    'textmate-elixir'=> {},
    'textmate-fish'=> {},
    'textmate-onsave'=> {},
    'textmate-opencl'=> {},
    'textmate-rubocop'=> {},
    'transmission'=> {},
    'tower-beta'=> {},
    'unicodechecker'=> {},
    'vagrant'=> {},
    'vagrant-manager'=> {},
    'virtualbox'=> {},
    'vlc-nightly'=> {},
    'wineskin-winery'=> {},
    'xld' => { flags: ["--appdir=#{converters_dir}"] },
    'xnconvert' => { flags: ["--appdir=#{converters_dir}"] },
    'xquartz'=> {},
  }

  desc "Install Casks"
  task :casks do
    FileUtils.mkdir_p [itach_dir, "#{converters_dir}/.localized"]

    File.open("#{converters_dir}/.localized/de.strings", 'w') { |f|
      f.puts '"Converters" = "Konvertierungswerkzeuge";'
    }

    File.open("#{converters_dir}/.localized/en.strings", 'w') { |f|
      f.puts '"Converters" = "Conversion Tools";'
    }

    # Ensure directories exist and have correct permissions.
    [
      '/Library/LaunchAgents',
      '/Library/LaunchDaemons',
      '/Library/Dictionaries',
      '/Library/PreferencePanes',
      '/Library/QuickLook',
      '/Library/Services',
      '/Library/Screen Savers',
    ].each do |dir|
      command sudo, '/bin/mkdir', '-p', dir
      command sudo, '/usr/sbin/chown', 'root:admin', dir
      command sudo, '/bin/chmod', '-R', 'ug=rwx,o=rx', dir
    end

    dir_flags = [
      '--dictionarydir=/Library/Dictionaries',
      '--prefpanedir=/Library/PreferencePanes',
      '--qlplugindir=/Library/QuickLook',
      '--servicedir=/Library/Services',
      '--screen_saverdir=/Library/Screen Savers',
    ]

    installed_casks = capture('brew', 'cask', 'list').strip.split("\n")
    casks = CASKS.select { |cask, _|
      next false if installed_casks.include?(cask)
      next false if ci? && cask == 'virtualbox'
      true
    }

    begin
      ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

      download_pool = Concurrent::FixedThreadPool.new(10)
      install_pool = Concurrent::SingleThreadExecutor.new

      casks.map { |cask, flags: []|
        Concurrent::Promise
          .execute(executor: download_pool) { command 'brew', 'cask', 'fetch', cask, silent: true, tries: 3 }
          .then(executor: install_pool) { command 'brew', 'cask', 'install', cask, *dir_flags, *flags }
      }.each(&:wait!)
    ensure
      download_pool.shutdown
      install_pool.shutdown
    end
  end
end
