# frozen_string_literal: true

require 'macos'

task :rust => [:'brew:casks_and_formulae', :sccache] do
  puts ANSI.blue { 'Configuring Rust …' }

  cargo_home = '~/.config/cargo'
  rustup_home = '~/.config/rustup'

  ENV['CARGO_HOME'] = File.expand_path(cargo_home)

  add_line_to_file fish_environment('rust'), "set -x CARGO_HOME #{cargo_home}"
  add_line_to_file bash_environment, "export CARGO_HOME=#{cargo_home}"

  ENV['RUSTUP_HOME'] = File.expand_path(rustup_home)

  add_line_to_file fish_environment('rust'), "set -x RUSTUP_HOME #{rustup_home}"
  add_line_to_file bash_environment, "export RUSTUP_HOME=#{rustup_home}"

  ENV['PATH'] = "#{ENV.fetch('CARGO_HOME')}/bin:#{ENV.fetch('PATH')}"

  add_line_to_file fish_environment('rust'),
                   'mkdir -p "$CARGO_HOME/bin"; and ' \
                   'fish_add_path --global --move --path "$CARGO_HOME/bin"'
  add_line_to_file bash_environment,
                   'mkdir -p "$CARGO_HOME/bin" && export PATH="$CARGO_HOME/bin:$PATH"'

  rustup_prefix = capture('brew', '--prefix', 'rustup').chomp
  add_line_to_file fish_environment('rust'),
                   "fish_add_path --global --move --path \"#{rustup_prefix}/bin\""
  add_line_to_file bash_environment,
                   "export PATH=\"#{rustup_prefix}/bin:$PATH\""

  add_line_to_file fish_environment('rust'),
                   'set -x CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABIHF_LINKER arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file bash_environment,
                   'export CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file fish_environment('rust'), 'set -x CC_arm_unknown_linux_gnueabihf arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file bash_environment, 'export CC_arm_unknown_linux_gnueabihf=arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file fish_environment('rust'), 'set -x CXX_arm_unknown_linux_gnueabihf arm-unknown-linux-gnueabihf-gcc'
  add_line_to_file bash_environment, 'export CXX_arm_unknown_linux_gnueabihf=arm-unknown-linux-gnueabihf-gcc'

  FileUtils.mkdir_p ENV.fetch('CARGO_HOME')
  cargo_config = <<~TOML
    [net]
    git-fetch-with-cli = true
  TOML
  cargo_config += <<~TOML if macos?

    [registry]
    credential-process = "cargo:macos-keychain"
  TOML
  File.write "#{ENV.fetch('CARGO_HOME')}/config.toml", cargo_config

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

  begin
    capture('rustup', 'default')
  rescue NonZeroExit
    puts ANSI.blue { 'Setting default Rust toolchain …' }
    command 'rustup', 'default', 'stable'
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

  if installed_toolchains.any? { |toolchain| toolchain.match?(/^stable-(aarch64|x86_64)-apple-darwin$/) }
    puts ANSI.green { 'Rust stable toolchain already installed.' }
  else
    puts ANSI.blue { 'Installing Rust stable toolchain …' }
    command 'rustup', 'toolchain', 'install', 'stable'
  end

  if installed_toolchains.any? { |toolchain| toolchain.match?(/^nightly-(aarch64|x86_64)-apple-darwin$/) }
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
end
