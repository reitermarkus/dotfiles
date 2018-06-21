require 'environment'

task :ccache do
  puts ANSI.blue { 'Adding `ccache` to PATH …' }
  add_line_to_file fish_environment, 'brew list ccache ^&- >&-; and set -x fish_user_paths (brew --prefix ccache)/libexec $fish_user_paths'
  add_line_to_file bash_environment, 'brew list ccache 2>&1 >/dev/null && export PATH="$(brew --prefix ccache)/libexec:$PATH"'
end
