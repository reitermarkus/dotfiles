# frozen_string_literal: true

require 'macos_version'

task :rust => [:'brew:casks_and_formulae', :sccache] do
  cargo_home = '~/.config/cargo'
  rustup_home = '~/.config/rustup'

  ENV['CARGO_HOME'] = File.expand_path(cargo_home)

  add_line_to_file fish_environment, "set -x CARGO_HOME #{cargo_home}"
  add_line_to_file bash_environment, "export CARGO_HOME=#{cargo_home}"

  ENV['RUSTUP_HOME'] = File.expand_path(rustup_home)

  add_line_to_file fish_environment, "set -x RUSTUP_HOME #{rustup_home}"
  add_line_to_file bash_environment, "export RUSTUP_HOME=#{rustup_home}"

  ENV['PATH'] = "#{ENV.fetch('CARGO_HOME')}/bin:#{ENV.fetch('PATH')}"

  add_line_to_file fish_environment,
                   'mkdir -p "$CARGO_HOME/bin"; and set -x fish_user_paths "$CARGO_HOME/bin" $fish_user_paths'
  add_line_to_file bash_environment,
                   'mkdir -p "$CARGO_HOME/bin" && export PATH="$CARGO_HOME/bin:$PATH"'

  add_line_to_file fish_environment,
                   'set -x CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABIHF_LINKER arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file bash_environment,
                   'export CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file fish_environment, 'set -x CC_arm_unknown_linux_gnueabihf arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file bash_environment, 'export CC_arm_unknown_linux_gnueabihf=arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file fish_environment, 'set -x CXX_arm_unknown_linux_gnueabihf arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file bash_environment, 'export CXX_arm_unknown_linux_gnueabihf=arm-unknown-linux-gnueabihf-gcc'

  FileUtils.mkdir_p ENV.fetch('CARGO_HOME')
  File.write "#{ENV.fetch('CARGO_HOME')}/config", <<~TOML
    [unstable]
    credential-process = true

    [registry]
    credential-process = "cargo:macos-keychain"

    [net]
    git-fetch-with-cli = true
  TOML

  if macos?
    defaults 'com.macromates.TextMate' do
      write 'environmentVariables', [
        {
          'enabled' => true,
          'name' => 'CARGO_HOME',
          'value' => '$HOME/.config/cargo',
        },
        {
          'enabled' => true,
          'name' => 'PATH',
          'value' => '$CARGO_HOME/bin:$PATH',
        },
        {
          'enabled' => true,
          'name' => 'RUSTUP_HOME',
          'value' => '$HOME/.config/rustup',
        },
      ], add: true
    end
  end

  if which 'rustup'
    puts ANSI.blue { 'Updating Rust …' }
    command 'rustup', 'update'
  else
    puts ANSI.blue { 'Installing Rust …' }
    command 'rustup-init', '-y', '--no-modify-path'
  end
  installed_targets = capture('rustup', 'target', 'list', '--installed').lines.map(&:chomp)
  installed_toolchains = capture('rustup', 'toolchain', 'list').lines.map(&:chomp)

  ['arm-unknown-linux-gnueabihf'].each do |target|
    if installed_targets.include?(target)
      puts ANSI.green { "Rust #{target} target already installed." }
    else
      puts ANSI.blue { "Installing Rust #{target} target …" }
      command 'rustup', 'target', 'add', target
    end
  end

  if installed_toolchains.include?('stable-x86_64-apple-darwin')
    puts ANSI.green { 'Rust stable toolchain already installed.' }
  else
    puts ANSI.blue { 'Installing Rust stable toolchain …' }
    command 'rustup', 'toolchain', 'install', 'stable'
  end

  if installed_toolchains.include?('nightly-x86_64-apple-darwin')
    puts ANSI.green { 'Rust nightly toolchain already installed.' }
  else
    puts ANSI.blue { 'Installing Rust nightly toolchain …' }
    command 'rustup', 'toolchain', 'install', 'nightly'
  end

  installed_components = capture('rustup', 'component', 'list').lines.map { |line| line.split(/\s/).first }

  components = %w[
    rust-src
    rustfmt-preview
    clippy-preview
  ]

  components = components.select { |component|
    installed_components.none? { |installed_component|
      installed_component == component || installed_component.start_with?("#{component}-")
    }
  }

  if components.empty?
    puts ANSI.green { 'All Rust components already installed.' }
  else
    puts ANSI.blue { 'Installing Rust components …' }
    components.each do |component|
      command 'rustup', 'component', 'add', component, '--toolchain', 'stable'

      begin
        command 'rustup', 'component', 'add', component, '--toolchain', 'nightly'
      rescue NonZeroExit
        nil
      end
    end
  end

  if macos_version >= Gem::Version.new('10.15')
    if which 'cargo-add'
      puts ANSI.green { '`cargo-edit` already installed.' }
    else
      puts ANSI.blue { 'Installing `cargo-edit` …' }
      command 'cargo', 'install', 'cargo-edit'
    end
  end
end
