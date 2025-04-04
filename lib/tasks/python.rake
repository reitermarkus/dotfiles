# frozen_string_literal: true

task :python => [:asdf] do
  puts ANSI.blue { 'Configuring Python …' }

  add_line_to_file fish_environment('python'), 'set -x PYTHONDONTWRITEBYTECODE 1'
  add_line_to_file bash_environment, 'export PYTHONDONTWRITEBYTECODE=1'

  command 'asdf', 'plugin', 'add', 'python'
  command 'asdf', 'set', '--home', 'python', 'system'
end
