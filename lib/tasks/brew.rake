require 'ci'
require 'command'
require 'fileutils'
require 'which'

class TopologicalHash < Hash
  include TSort

  alias tsort_each_node each_key

  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

def dependencies(keys, acc: TopologicalHash.new)
  pool = Concurrent::FixedThreadPool.new(10)

  promises = keys.map { |key|
    next if acc.key?(key)

    type, name = key

    promise = case type
    when :cask
      Concurrent::Promise.execute(executor: pool) {
        capture('brew', 'cask', 'cat', name).lines.reduce([]) do |a, line|
          if /depends_on\s+formula:\s*(?:"(?<formula>.*)"|'(?<formula>.*)')/ =~ line
            [*a, [:formula, formula]]
          elsif /depends_on\s+cask:\s*(?:"(?<cask>.*)"|'(?<cask>.*)')/  =~ line
            [*a, [:cask, cask]]
          else
            a
          end
        end
      }
    when :formula
      Concurrent::Promise.execute(executor: pool) {
        capture('brew', 'deps', name).lines.map { |line| [:formula, line.strip] }
      }
    end

    [key, promise]
  }.compact

  key_deps = promises.map { |key, promise| [key, promise.value!] }

  pool.shutdown

  key_deps.each do |key, deps|
    acc[key] = deps
  end

  key_deps.each do |_, deps|
    dependencies(deps, acc: acc)
  end

  acc
end

task :brew => [:'brew:install', :'brew:taps', :'brew:casks_and_formulae']

namespace :brew do
  desc 'Install Homebrew'
  task :install do
    ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

    if which 'brew'
      puts ANSI.blue { 'Updating Homebrew …' }
      command 'brew', 'update', '--force'
    else
      puts ANSI.blue { 'Installing Homebrew …' }
      command '/usr/bin/ruby', '-e', capture('/usr/bin/curl', '-fsSL', 'https://raw.githubusercontent.com/Homebrew/install/master/install')
    end
  end

  desc "Install Taps"
  task :taps do
    ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

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

    if taps.empty?
      puts ANSI.green { 'All Homebrew Taps already installed.' }
    else
      puts ANSI.blue { 'Installing Homebrew Taps …' }
    end

    begin
      download_pool = Concurrent::FixedThreadPool.new(10)

      taps.map { |tap|
        Concurrent::Promise
          .execute(executor: download_pool) { command 'brew', 'tap', tap }
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
    'imageoptim-cli' => {},
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

  desc 'Install Casks and Formulae'
  task :casks_and_formulae do
    ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

    casks = CASKS.keys.reject { |cask| ci? && ['unicodechecker', 'virtualbox'].include?(cask) }
    formulae = FORMULAE.keys

    all_keys = formulae.map { |formula| [:formula, formula] } + casks.map { |cask| [:cask, cask] }

    dependency_graph = dependencies(all_keys)

    dependency_graph[[:formula, 'sshfs']] << [:cask, 'osxfuse']

    installed_casks = capture('brew', 'cask', 'list').strip.split("\n")
    installed_formulae = capture('brew', 'list').strip.split("\n")

    if ((casks - installed_casks) + (formulae - installed_formulae)).empty?
      puts ANSI.green { 'All Casks and Formulae already installed.' }
      next
    else
      puts ANSI.blue { 'Installing Casks and Formulae …' }
    end

    sorted_dependency_graph = dependency_graph.tsort

    recursive_dependencies = ->(key) {
      deps = dependency_graph[key]

      if deps.empty?
        []
      else
        (deps + deps.flat_map { |dep| recursive_dependencies.call(dep) }).uniq
      end
    }

    sorted_dependency_graph.each_with_index do |key, i|
      deps = recursive_dependencies.call(key)

      deps.each do |dep|
        next if all_keys.include?(dep)

        sorted_dependency_graph.take(i).each do |previous_key|
          next if deps.include?(previous_key)
          next unless all_keys.include?(previous_key)

          if dependency_graph[previous_key].include?(dep)
            deps << previous_key
            break
          end
        end
      end

      dependency_graph[key] = deps
    end

    download_pool = Concurrent::FixedThreadPool.new(10)
    downloads = {}

    sorted_dependency_graph.each do |key|
      type, name = key

      case type
      when :cask
        next if installed_casks.include?(name)

        downloads[key] = Concurrent::Promise.execute(executor: download_pool) {
          command 'brew', 'cask', 'fetch', name, silent: true, tries: 3
        }
      when :formula
        next if installed_formulae.include?(name)

        downloads[key] = Concurrent::Promise.execute(executor: download_pool) {
          command 'brew', 'fetch', '--retry', name, silent: true, tries: 3
        }
      end
    end

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

    cask_install_pool = Concurrent::FixedThreadPool.new(5)
    formula_install_pool = Concurrent::FixedThreadPool.new(2)
    install_finished_pool = Concurrent::SingleThreadExecutor.new
    cleanup_pool = Concurrent::SingleThreadExecutor.new

    installations = {}

    wait_for_downloads = ->(key, executor:) {
      Concurrent::Promise.new(executor: executor) {
        deps = dependency_graph[key]

        [*deps, key].each do |k|
          downloads[k]&.wait!
        end


        deps.each do |k|
          installations[k]&.wait!
        end
      }
    }

    begin
      cask_promises = casks.map { |cask| [cask, CASKS[cask]] }.map { |cask, flags: [], **|
        key = [:cask, cask]

        installations[key] = begin
          promise = wait_for_downloads.call(key, executor: cask_install_pool)

          if installed_casks.include?(cask)
            promise
          else
            promise
              .then { capture 'brew', 'cask', 'install', cask, *dir_flags, *flags, stdout_tty: true }
              .then(executor: install_finished_pool) { |out, _| print out }
              .then(executor: cleanup_pool) { capture 'brew', 'cask', 'cleanup', cask if ci? }
          end
        end
      }

      formula_promises = formulae.map { |formula| [formula, FORMULAE[formula]] }.map { |formula, **|
        key = [:formula, formula]

        installations[key] = begin
          promise = wait_for_downloads.call(key, executor: formula_install_pool)

          if installed_formulae.include?(formula)
            promise
          else
            promise
              .then { capture 'brew', 'install', formula, stdout_tty: true }
              .then(executor: install_finished_pool) { |out, _| print out }
              .then(executor: cleanup_pool) { capture 'brew', 'cleanup', formula if ci? }
          end
        end
      }

      cask_promises.each(&:execute)
      formula_promises.each(&:execute)

      cask_promises.each(&:wait!)
      formula_promises.each(&:wait!)
    ensure
      cask_install_pool.shutdown
      formula_install_pool.shutdown
      install_finished_pool.shutdown
      cleanup_pool.shutdown
    end
  end
end
