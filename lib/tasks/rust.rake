task :rust do
  command 'rustup-init', '-y', '--no-modify-path'

  cargo_bin = '~/.cargo/bin'

  ENV['PATH'] = "#{File.expand_path(cargo_bin)}:#{ENV['PATH']}"

  add_line_to_file fish_environment, "mkdir -p #{cargo_bin}; and set -x fish_user_paths #{cargo_bin} $fish_user_paths"
  add_line_to_file bash_environment, "mkdir -p #{cargo_bin} && export PATH=#{cargo_bin}:\"$PATH\""

  command 'rustup', 'update'

  command 'rustup', 'component', 'add', 'rust-src'

  command 'cargo', 'install', 'racer' unless which 'racer'
end
