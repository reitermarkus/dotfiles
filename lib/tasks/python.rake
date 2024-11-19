# frozen_string_literal: true

task :python do
  add_line_to_file fish_environment, 'set -x PYTHONDONTWRITEBYTECODE 1'
  add_line_to_file bash_environment, 'export PYTHONDONTWRITEBYTECODE=1'
end
