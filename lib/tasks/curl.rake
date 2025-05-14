# frozen_string_literal: true

task :curl do
  add_line_to_file fish_environment('curl'), "set -x NETRC ~/.config/netrc"
  add_line_to_file bash_environment, "export NETRC=~/.config/netrc"
end
