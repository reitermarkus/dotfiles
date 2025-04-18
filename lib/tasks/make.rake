# frozen_string_literal: true

require 'environment'

task :make do
  add_line_to_file fish_environment('make'),
                   'set -l cores (/usr/sbin/sysctl -n hw.ncpu); and set -x MAKEFLAGS "-j $cores"'
  add_line_to_file bash_environment,
                   'cores="$(/usr/sbin/sysctl -n hw.ncpu)" && export MAKEFLAGS="-j $cores"'
end
