require 'environment'

task :make do
  processors = capture('/usr/sbin/sysctl', '-n', 'hw.ncpu').strip
  add_line_to_file fish_environment, "set -x MAKEFLAGS -j#{processors} -l#{processors}"
  add_line_to_file bash_environment, "export MAKEFLAGS='-j#{processors} -l#{processors}'"
end
