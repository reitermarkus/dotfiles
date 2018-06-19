require 'ci'
require 'command'
require 'fileutils'
require 'which'
require 'shellwords'

class TopologicalHash < Hash
  include TSort

  alias tsort_each_node each_key

  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

def dependencies(keys, acc: TopologicalHash.new, pool: nil)
  shutdown = pool.nil?
  pool ||= Concurrent::FixedThreadPool.new(10)

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

  key_deps.each do |key, deps|
    acc[key] = deps
  end

  key_deps.each do |_, deps|
    dependencies(deps, acc: acc, pool: pool)
  end

  acc
ensure
  pool.shutdown if shutdown
end

task :brew => [:'brew:install', :'brew:taps', :'brew:casks_and_formulae']

namespace :brew do
  desc 'Install Homebrew'
  task :install => [:'xcode:command_line_utilities'] do
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
  task :taps => [:'brew:install'] do
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
      output_pool = Concurrent::SingleThreadExecutor.new

      taps.map { |tap|
        Concurrent::Promise.execute(executor: download_pool) {
          capture 'brew', 'tap', tap, stdout_tty: true
        }
        .then(executor: output_pool) { |out|
          print out
        }
      }.each(&:wait!)
    ensure
      output_pool.shutdown
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
    'svgexport' => {},
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
    'textmate-glsl' => {},
    'textmate-javascript-babel' => {},
    'textmate-javascript-eslint' => {},
    'textmate-onsave'=> {},
    'textmate-opencl'=> {},
    'textmate-openhab' => {},
    'textmate-rubocop'=> {},
    'textmate-rust'=> {},
    'textmate-solarized' => {},
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
  task :casks_and_formulae => [:'brew:taps'] do
    ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'

    ENV['HOMEBREW_CASK_OPTS'] = [
      '--appdir=/Applications',
      '--dictionarydir=/Library/Dictionaries',
      '--colorpickerdir=/Library/ColorPickers',
      '--prefpanedir=/Library/PreferencePanes',
      '--qlplugindir=/Library/QuickLook',
      '--servicedir=/Library/Services',
      '--screen_saverdir=/Library/Screen Savers',
    ].shelljoin.gsub(/\\=/, '=')

    add_line_to_file fish_environment, "set -x HOMEBREW_CASK_OPTS '#{ENV['HOMEBREW_CASK_OPTS']}'"
    add_line_to_file bash_environment, "export HOMEBREW_CASK_OPTS='#{ENV['HOMEBREW_CASK_OPTS']}'"

    add_line_to_file fish_environment, "set -x HOMEBREW_DEVELOPER 1"
    add_line_to_file bash_environment, "export HOMEBREW_DEVELOPER='1'"

    api_token = '0e3924d278578977b3bd88980c71877e0c426184'
    add_line_to_file fish_environment, "set -x HOMEBREW_GITHUB_API_TOKEN #{api_token}"
    add_line_to_file bash_environment, "export HOMEBREW_GITHUB_API_TOKEN='#{api_token}'"

    installed_casks = capture('brew', 'cask', 'list').strip.split("\n")
    installed_formulae = capture('brew', 'list').strip.split("\n")

    casks = CASKS.keys.reject { |cask| ci? && ['unicodechecker', 'virtualbox'].include?(cask) } - installed_casks
    formulae = FORMULAE.keys - installed_formulae

    if (casks + formulae).empty?
      puts ANSI.green { 'All Casks and Formulae already installed.' }
      next
    else
      puts ANSI.blue { 'Installing Casks and Formulae …' }
    end

    all_keys = formulae.map { |formula| [:formula, formula] } + casks.map { |cask| [:cask, cask] }

    dependency_graph = dependencies(all_keys)

    if dependency_graph.key?([:formula, 'sshfs'])
      dependency_graph[[:formula, 'sshfs']] << [:cask, 'osxfuse']
    end

    recursive_dependencies = ->(key) {
      dependency_graph.fetch(key, []).flat_map { |dep|
        [*recursive_dependencies.call(dep), dep]
      }.uniq
    }

    dependency_graph.each do |key, _|
      dependency_graph[key] = recursive_dependencies.call(key)
    end

    sorted_dependencies = dependency_graph.tsort

    sorted_dependencies.each_with_index do |key, i|
      previous_deps = sorted_dependencies.take(i)

      dependency_graph[key] = dependency_graph[key].flat_map { |dep|
        next [dep] if all_keys.include?(dep)

        # Find closest previous explicitly-installed dependency which also depends on `dep`.
        previous_dep = previous_deps.detect { |previous_key|
          next unless all_keys.include?(previous_key)
          next unless dependency_graph[previous_key].include?(dep)
          previous_key
        }

        if previous_dep
          [previous_dep, dep]
        else
          [dep]
        end
      }.uniq
    end

    sorted_dependencies = dependency_graph.tsort

    download_pool = Concurrent::FixedThreadPool.new(10)
    downloads = {}

    sorted_dependencies.each do |key|
      type, name = key

      downloads[key] = case type
      when :cask
        Concurrent::Promise.new(executor: download_pool) {
          command 'brew', 'cask', 'fetch', name, silent: true, tries: 3
        }
      when :formula
        Concurrent::Promise.new(executor: download_pool) {
          command 'brew', 'fetch', '--retry', name, silent: true, tries: 3
        }
      end
    end

    # Start MacTeX downloads first because it is by far the biggest.
    mactex_key = [:cask, 'mactex-no-gui']
    [mactex_key, *dependency_graph[mactex_key]].each do |key|
      downloads[key]&.execute
    end

    sorted_dependencies.each do |key|
      downloads[key].execute
    end

    FileUtils.mkdir_p [itach_dir, "#{converters_dir}/.localized"]

    File.write "#{converters_dir}/.localized/de.strings", <<~EOS
      "Converters" = "Konvertierungswerkzeuge";
    EOS

    File.write "#{converters_dir}/.localized/en.strings", <<~EOS
      "Converters" = "Conversion Tools";
    EOS

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

    download_wait_pool = Concurrent::CachedThreadPool.new
    install_pool = Concurrent::FixedThreadPool.new(10)
    install_finished_pool = Concurrent::SingleThreadExecutor.new
    cleanup_pool = Concurrent::SingleThreadExecutor.new

    installations = {}

    wait_for_downloads = ->(key) {
      Concurrent::Promise.new(executor: download_wait_pool) {
        deps = dependency_graph[key]

        deps.each do |k|
          downloads[k]&.wait!
          installations[k]&.wait!
        end

        downloads[key]&.wait!
      }
    }

    def safe_install
      tries = 120

      begin
        yield
      rescue NonZeroExit => e
        if e.stderr =~ /Another active Homebrew process/
          tries -= 1

          if tries > 0
            sleep 1
            retry
          end
        end

        raise e
      end
    end

    begin
      casks.map { |cask| [cask, CASKS[cask]] }.each { |cask, flags: [], **|
        key = [:cask, cask]

        installations[key] =
          wait_for_downloads.call(key)
            .then(executor: install_pool) {
              safe_install do
                capture 'brew', 'cask', 'install', cask, *flags, stdout_tty: true
              end
            }
            .then(executor: install_finished_pool) { |out, _| print out }
            .then(executor: cleanup_pool) { capture 'brew', 'cask', 'cleanup', cask if ci? }
      }

      formulae.map { |formula| [formula, FORMULAE[formula]] }.each { |formula, **|
        key = [:formula, formula]

        installations[key] =
          wait_for_downloads.call(key)
            .then(executor: install_pool) {
              safe_install do
                capture 'brew', 'install', formula, stdout_tty: true
              end
            }
            .then(executor: install_finished_pool) { |out, _| print out }
            .then(executor: cleanup_pool) { capture 'brew', 'cleanup', formula if ci? }
      }

      sorted_dependencies.each do |key|
        installations[key]&.execute
      end

      sorted_dependencies.each do |key|
        installations[key]&.wait!
      end
    ensure
      install_pool.shutdown
      install_finished_pool.shutdown
      cleanup_pool.shutdown
    end
  end
end
