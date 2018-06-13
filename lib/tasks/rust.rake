task :rust do
  cargo_home = '~/.config/cargo'
  rustup_home = '~/.config/rustup'

  ENV['CARGO_HOME'] = File.expand_path(cargo_home)

  add_line_to_file fish_environment, "set -x CARGO_HOME #{cargo_home}"
  add_line_to_file bash_environment, "export CARGO_HOME=#{cargo_home}"

  ENV['RUSTUP_HOME'] = File.expand_path(rustup_home)

  add_line_to_file fish_environment, "set -x RUSTUP_HOME #{rustup_home}"
  add_line_to_file bash_environment, "export RUSTUP_HOME=#{rustup_home}"

  command 'rustup-init', '-y', '--no-modify-path'

  cargo_bin = "#{cargo_home}/bin"

  ENV['PATH'] = "#{File.expand_path(cargo_bin)}:#{ENV['PATH']}"

  add_line_to_file fish_environment, "mkdir -p #{cargo_bin}; and set -x fish_user_paths #{cargo_bin} $fish_user_paths"
  add_line_to_file bash_environment, "mkdir -p #{cargo_bin} && export PATH=#{cargo_bin}:\"$PATH\""

  command 'rustup', 'update'

  command 'rustup', 'component', 'add', 'rust-src'

  command 'cargo', 'install', 'racer' unless which 'racer'
end
