# frozen_string_literal: true

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
        capture('brew', 'cat', '--cask', name).lines.reduce([]) do |a, line|
          if /depends_on\s+formula:\s*(?:"(?<formula>.*)"|'(?<formula>.*)')/ =~ line
            [*a, [:formula, formula]]
          elsif /depends_on\s+cask:\s*(?:"(?<cask>.*)"|'(?<cask>.*)')/ =~ line
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
  }.compact.to_h

  key_deps = promises.transform_values(&:value!)

  key_deps.each do |key, deps|
    acc[key] = deps
  end

  key_deps.each_value do |deps|
    dependencies(deps, acc: acc, pool: pool)
  end

  acc
ensure
  pool.shutdown if shutdown
end

task :brew => [:'brew:install', :'brew:taps', :'brew:casks_and_formulae', :'brew:services']

namespace :brew do
  desc 'Install Homebrew'
  task :install => [:'xcode:command_line_utilities'] do
    ENV['HOMEBREW_NO_AUTO_UPDATE'] = '1'
    ENV['HOMEBREW_NO_INSTALL_CLEANUP'] = '1'
    ENV['HOMEBREW_VERBOSE'] = '1' if ci?
    ENV['HOMEBREW_DEBUG'] = '1' if ci?

    if which 'brew'
      puts ANSI.blue { 'Updating Homebrew …' }
      command 'brew', 'update', '--force'
    else
      puts ANSI.blue { 'Installing Homebrew …' }
      command '/bin/bash', '-c', capture('/usr/bin/curl', '-fsSL', 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh')
    end

    brew_prefix = capture('brew', '--prefix').chomp

    [File.join(brew_prefix, 'bin'), File.join(brew_prefix, 'sbin')].map(&:shellescape).each do |bin|
      add_line_to_file fish_environment, "contains #{bin} $PATH; " \
                                         "or set -x fish_user_paths #{bin} $fish_user_paths"
      add_line_to_file bash_environment, "[[ \":$PATH:\" =~ :#{bin}: ]] || " \
                                         "export PATH=#{bin}:\"$PATH\""
    end

    brew_repo_dir = capture('brew', '--repository').chomp
    brew_repo_remotes = capture('git', '-C', brew_repo_dir, 'remote').lines.map(&:chomp)
    if brew_repo_remotes.include?('reitermarkus')
      command 'git', '-C', brew_repo_dir, 'remote', 'set-url', 'reitermarkus', 'https://github.com/reitermarkus/brew'
    else
      command 'git', '-C', brew_repo_dir, 'remote', 'add', 'reitermarkus', 'https://github.com/reitermarkus/brew'
    end
  end

  desc 'Install Taps'
  task :taps => [:'brew:install'] do
    wanted_taps = %w[
      homebrew/cask
      homebrew/cask-drivers
      homebrew/cask-fonts
      homebrew/cask-versions
      homebrew/command-not-found
      homebrew/services

      jonof/kenutils
      reitermarkus/tap
      bfontaine/utils
    ].freeze

    taps = wanted_taps - capture('brew', 'tap').strip.split("\n")

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
        }.then(executor: output_pool) { |out|
          print out
        }
      }.each(&:wait!)
    ensure
      output_pool.shutdown
      download_pool.shutdown
    end
  end

  wanted_formulae = {
    'ansible' => {},
    'asimov' => {},
    'bash' => {},
    'bash-completion' => {},
    'carthage' => {},
    'ccache' => {},
    'clang-format' => {},
    'cmake' => {},
    'duti' => {},
    'gcc' => {},
    'gcc-arm-unknown-linux-gnueabihf@8' => {},
    'git' => {},
    'git-extras' => {},
    'gnupg' => {},
    'imageoptim-cli' => {},
    'iperf3' => {},
    'fish' => {},
    'fisher' => {},
    'helm' => {},
    'jq' => {},
    'krew' => {},
    'llvm' => {},
    'lockscreen' => {},
    'mackup' => {},
    'mas' => {},
    'mosh' => {},
    'ncdu' => {},
    'nvm' => {},
    'openjdk' => {},
    'pam-touch-id' => {},
    'pinentry-mac' => {},
    'pngout' => {},
    'python' => {},
    'rbenv' => {},
    'rbenv-binstubs' => {},
    'rbenv-system-ruby' => {},
    'rbenv-bundler-ruby-version' => {},
    'rfc' => {},
    'rustup-init' => {},
    'sccache' => {},
    'sops' => {},
    'svgexport' => {},
    'terminal-notifier' => {},
    'thefuck' => {},
    'telnet' => {},
    'tree' => {},
    'unison' => {},
    'watch' => {},
    'yarn' => {},
    'yq' => {},
  }.freeze

  converters_dir = '/Applications/Converters.localized'
  itach_dir = '/Applications/iTach'

  wanted_casks = {
    'a-better-finder-rename' => {},
    'aerial' => {},
    'araxis-merge' => {},
    'arduino' => {},
    'bibdesk' => {},
    'calibre' => {},
    'chromium' => {},
    'cyberduck' => {},
    'daisydisk' => {},
    'detexify' => {},
    'docker' => {},
    'epub-services' => {},
    'evernote' => {},
    'firefox' => {},
    'fluor' => {},
    'fork' => {},
    'font-meslo-lg-nerd-font' => {},
    'handbrake' => { flags: ["--appdir=#{converters_dir}"] },
    'hazel' => {},
    'hex-fiend' => {},
    'image2icon' => { flags: ["--appdir=#{converters_dir}"] },
    'imageoptim' => { flags: ["--appdir=#{converters_dir}"] },
    'keka' => {},
    'konica-minolta-bizhub-c750i-driver' => {},
    'latexit' => {},
    'minecraft' => {},
    'macdown' => {},
    'mactex-no-gui' => {},
    'makemkv' => { flags: ["--appdir=#{converters_dir}"] },
    'mediathekview' => {},
    'monitorcontrol' => {},
    'mysides' => {},
    'netspot' => {},
    'macfuse' => {},
    'origin' => {},
    'otp-auth' => {},
    'prizmo' => {},
    'postman' => {},
    'qlmarkdown' => {},
    'qlstephen' => {},
    'rocket' => {},
    'sequel-pro' => {},
    'sigil' => {},
    'slack' => {},
    'skim' => {},
    'steam' => {},
    'steermouse' => {},
    'db-browser-for-sqlite' => {},
    'svgcleaner' => {},
    'table-tool' => {},
    'telegram' => {},
    'tex-live-utility' => {},
    'textmate-preview' => {},
    'textmate-crystal' => {},
    'textmate-cucumber' => {},
    'textmate-editorconfig' => {},
    'textmate-elixir' => {},
    'textmate-fish' => {},
    'textmate-glsl' => {},
    'textmate-javascript-babel' => {},
    'textmate-javascript-eslint' => {},
    'textmate-onsave' => {},
    'textmate-opencl' => {},
    'textmate-openhab' => {},
    'textmate-rubocop' => {},
    'textmate-rust' => {},
    'textmate-solarized' => {},
    'transmission' => {},
    'unicodechecker' => {},
    'vagrant' => {},
    'vagrant-manager' => {},
    'virtualbox' => {},
    'vlc' => {},
    'xld' => { flags: ["--appdir=#{converters_dir}"] },
    'xnconvert' => { flags: ["--appdir=#{converters_dir}"] },
    'xquartz' => {},
  }.freeze

  desc 'Install Casks and Formulae'
  task :casks_and_formulae => [:'brew:taps'] do
    ENV['HOMEBREW_FORCE_BREWED_CURL'] = '1' if ci?
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

    add_line_to_file fish_environment, 'set -x HOMEBREW_DEVELOPER 1'
    add_line_to_file bash_environment, "export HOMEBREW_DEVELOPER='1'"

    add_line_to_file fish_environment,
                     'test -e ~/.config/github/token; and read -x HOMEBREW_GITHUB_API_TOKEN < ~/.config/github/token'
    add_line_to_file bash_environment,
                     '[ -e ~/.config/github/token ] && ' \
                     'read HOMEBREW_GITHUB_API_TOKEN < ~/.config/github/token && export HOMEBREW_GITHUB_API_TOKEN'

    installed_casks = capture('brew', 'list', '--cask').strip.split("\n")
    installed_formulae = capture('brew', 'list', '--formula').strip.split("\n")

    casks = wanted_casks.keys - installed_casks
    formulae = wanted_formulae.keys - installed_formulae

    if (casks + formulae).empty?
      puts ANSI.green { 'All Casks and Formulae already installed.' }
      next
    else
      puts ANSI.blue { 'Installing Casks and Formulae …' }
    end

    all_keys = formulae.map { |formula| [:formula, formula] } + casks.map { |cask| [:cask, cask] }

    dependency_graph = dependencies(all_keys)

    recursive_dependencies = lambda { |key|
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

      downloads[key] = Concurrent::Promise.new(executor: download_pool) {
        command 'brew', 'fetch', '--retry', "--#{type}", name, silent: true, tries: 3 do |stream, line|
          throw :kill, 'INT' if stream == :stdout && line.include?('/Library/Caches/')
        end
      }
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

    File.write "#{converters_dir}/.localized/de.strings", <<~STRINGS
      "Converters" = "Konvertierungswerkzeuge";
    STRINGS

    File.write "#{converters_dir}/.localized/en.strings", <<~STRINGS
      "Converters" = "Conversion Tools";
    STRINGS

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
      command sudo, '/bin/chmod', '-R', '=rx,ug+w', dir
    end

    download_wait_pool = Concurrent::CachedThreadPool.new
    install_pool = Concurrent::FixedThreadPool.new(20)
    install_finished_pool = Concurrent::SingleThreadExecutor.new
    cleanup_pool = Concurrent::SingleThreadExecutor.new

    installations = {}

    wait_for_downloads = lambda { |key|
      Concurrent::Promise.new(executor: download_wait_pool) {
        deps = dependency_graph[key]

        deps.each do |k|
          downloads[k]&.wait!
          installations[k]&.wait!
        end

        downloads[key]&.wait!
      }
    }

    def safe_install(ignore_exception: false)
      tries = 5 * 60

      begin
        yield
      rescue NonZeroExit => e
        if e.stderr =~ /Another active Homebrew process/ || e.stderr =~ /is not there/
          tries -= 1

          if tries.positive?
            sleep 1
            retry
          end
        end

        ignore_exception ? return : raise
      end
    end

    begin
      packages = casks.map { |cask| [:cask, cask, wanted_casks[cask]] } +
                 formulae.map { |formula| [:formula, formula, wanted_formulae[formula]] }

      packages.each do |type, cask_or_formula, **|
        key = [type, cask_or_formula]

        ignored_exceptions = ['virtualbox', 'netspot']

        installations[key] =
          wait_for_downloads.call(key)
            .then(executor: install_pool) {
              safe_install(ignore_exception: ignored_exceptions.include?(cask_or_formula)) do
                capture 'brew', 'install', "--#{type}", cask_or_formula, stdout_tty: true
              end
            }
            .then(executor: install_finished_pool) { |out, _| print out }
            .then(executor: cleanup_pool) {
              begin
                capture 'brew', 'cleanup', cask_or_formula if ci?
              rescue NonZeroExit
              end
            }
      end

      sorted_dependencies
        .map { |key| installations[key] }.compact
        .map(&:execute).each(&:wait!)
    ensure
      install_pool.shutdown
      install_finished_pool.shutdown
      cleanup_pool.shutdown
    end
  end

  task :services => :'brew:casks_and_formulae' do
    wanted_services = ['asimov']
    services = capture(sudo, 'brew', 'services', 'list')
                 .each_line
                 .map { |l| l.strip.split(/\s+/, 2) }.to_h

    wanted_services.each do |service|
      capture sudo, 'brew', 'services', 'start', service if services.fetch(service) == 'stopped'
    end
  end
end
