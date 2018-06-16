task :z do
  add_line_to_file fish_environment, 'set -x Z_DATA ~/.config/z'
  add_line_to_file bash_environment, 'export Z_DATA=~/.config/z'
end
