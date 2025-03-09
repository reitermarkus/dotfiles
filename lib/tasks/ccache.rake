# frozen_string_literal: true

require 'environment'

task :ccache do
  puts ANSI.blue { 'Adding `ccache` to PATH …' }
  add_line_to_file fish_environment('ccache'), 'set -x CCACHE_DIR ~/.config/ccache'
  add_line_to_file bash_environment, 'export CCACHE_DIR=~/.config/ccache'

  add_line_to_file fish_environment('ccache'), 'set -x CCACHE_COMPRESS'
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

  add_line_to_file fish_environment('ccache'),
                   'brew list ccache 2>&- >&-; ' \
                   'and fish_add_path --global --move --path (brew --prefix ccache)/libexec'
  add_line_to_file bash_environment,
                   'brew list ccache 2>&1 >/dev/null && export PATH="$(brew --prefix ccache)/libexec:$PATH"'
end
