task :rust do
  command 'rustup-init', '-y', '--no-modify-path'
  command 'rustup', 'update'

  command 'rustup', 'component', 'add', 'rust-src'

  command 'cargo', 'install', 'racer' unless which 'racer'
end
