# frozen_string_literal: true

task :rust => [:'brew:casks_and_formulae', :sccache] do
  cargo_home = '~/.config/cargo'
  rustup_home = '~/.config/rustup'

  ENV['CARGO_HOME'] = File.expand_path(cargo_home)

  add_line_to_file fish_environment, "set -x CARGO_HOME #{cargo_home}"
  add_line_to_file bash_environment, "export CARGO_HOME=#{cargo_home}"

  ENV['RUSTUP_HOME'] = File.expand_path(rustup_home)

  add_line_to_file fish_environment, "set -x RUSTUP_HOME #{rustup_home}"
  add_line_to_file bash_environment, "export RUSTUP_HOME=#{rustup_home}"

  ENV['PATH'] = "#{ENV['CARGO_HOME']}/bin:#{ENV['PATH']}"

  add_line_to_file fish_environment, 'mkdir -p "$CARGO_HOME/bin"; and set -x fish_user_paths "$CARGO_HOME/bin" $fish_user_paths'
  add_line_to_file bash_environment, 'mkdir -p "$CARGO_HOME/bin" && export PATH="$CARGO_HOME/bin:$PATH"'

  FileUtils.mkdir_p ENV['CARGO_HOME']
  File.write "#{ENV['CARGO_HOME']}/config", <<~TOML
    [net]
    git-fetch-with-cli = true
  TOML

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

  if which 'rustup'
    puts ANSI.blue { 'Updating Rust …' }
    command 'rustup', 'update'
  else
    puts ANSI.blue { 'Installing Rust …' }
    command 'rustup-init', '-y', '--no-modify-path'
  end

  # Last nightly which supports all needed components.
  # https://rust-lang.github.io/rustup-components-history/x86_64-apple-darwin.html
  nightly = 'nightly-2019-06-01'

  installed_toolchains = capture('rustup', 'toolchain', 'list').lines.map(&:chomp)

  if installed_toolchains.include?('nightly-x86_64-apple-darwin')
    puts ANSI.green { 'Rust nightly toolchain already installed.' }
  else
    puts ANSI.blue { 'Installing Rust nightly toolchain …' }
    command 'rustup', 'toolchain', 'install', nightly
  end

  ['toolchains', 'update-hashes'].each do |dir|
    next unless File.exist?("#{ENV['RUSTUP_HOME']}/#{dir}/#{nightly}-x86_64-apple-darwin")

    FileUtils.rm_rf "#{ENV['RUSTUP_HOME']}/#{dir}/nightly-x86_64-apple-darwin"
    FileUtils.mv    "#{ENV['RUSTUP_HOME']}/#{dir}/#{nightly}-x86_64-apple-darwin",
                    "#{ENV['RUSTUP_HOME']}/#{dir}/nightly-x86_64-apple-darwin"
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
      command 'rustup', 'component', 'add', component, '--toolchain', 'nightly'
    end
  end

  if which 'cargo-add'
    puts ANSI.green { '`cargo-edit` already installed.' }
  else
    puts ANSI.blue { 'Installing `cargo-edit` …' }
    command 'cargo', 'install', 'cargo-edit'
  end

  if which 'racer'
    puts ANSI.green { '`racer` already installed.' }
  else
    puts ANSI.blue { 'Installing `racer` …' }
    command 'cargo', '+nightly', 'install', 'racer'
  end
end
