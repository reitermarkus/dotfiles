require 'environment'

task :make do
  add_line_to_file fish_environment, 'set -l cores (/usr/sbin/sysctl -n hw.ncpu); and set -x MAKEFLAGS "-j $cores -l $cores"'
  add_line_to_file bash_environment, 'cores="$(/usr/sbin/sysctl -n hw.ncpu)" && export MAKEFLAGS="-j $cores -l $cores"'
end
