require 'environment'

task :ccache do
  puts ANSI.blue { 'Adding `ccache` to PATH …' }
  add_line_to_file fish_environment, 'set -x CCACHE_DIR ~/.config/ccache'
  add_line_to_file bash_environment, 'export CCACHE_DIR=~/.config/ccache'

  add_line_to_file fish_environment, 'set -x CCACHE_COMPRESS'
  add_line_to_file bash_environment, 'export CCACHE_COMPRESS='

  defaults 'com.macromates.TextMate' do
    write 'environmentVariables', [
      {
        'enabled' => true,
        'name' => 'CCACHE_DIR',
        'value' => '$HOME/.config/ccache',
      },
      {
        'enabled' => true,
        'name' => 'CCACHE_COMPRESS',
        'value' => '',
      },
    ], add: true
  end

  add_line_to_file fish_environment, 'brew list ccache ^&- >&-; and set -x fish_user_paths (brew --prefix ccache)/libexec $fish_user_paths'
  add_line_to_file bash_environment, 'brew list ccache 2>&1 >/dev/null && export PATH="$(brew --prefix ccache)/libexec:$PATH"'
end
