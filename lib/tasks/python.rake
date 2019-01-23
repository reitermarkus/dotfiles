# frozen_string_literal: true

task :python => [:'brew:casks_and_formulae'] do
  if which('pip')
    # Install `six` in order not to break LLDB when non-system Python is first in `PATH`.
    installed = begin
      capture('pip', 'show', 'six')
    rescue NonZeroExit
      false
    end

    command 'pip', 'install', 'six' unless installed
  end

  add_line_to_file fish_environment, 'set -x PYTHONDONTWRITEBYTECODE 1'
  add_line_to_file bash_environment, 'export PYTHONDONTWRITEBYTECODE=1'
end
