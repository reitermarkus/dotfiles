task :rfc do
  puts ANSI.blue { 'Setting `rfc` configuration directory …' }
  add_line_to_file fish_environment, 'set -x RFC_DIR ~/.config/rfc'
  add_line_to_file bash_environment, 'export RFC_DIR=~/.config/rfc'
end
