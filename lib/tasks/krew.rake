# frozen_string_literal: true

require 'environment'
require 'add_line_to_file'

task :krew => :fish do
  krew_root = '~/.config/krew'

  ENV['KREW_ROOT'] = File.expand_path(krew_root)
  ENV['PATH'] = "#{ENV.fetch('KREW_ROOT')}/bin:#{ENV.fetch('PATH')}"

  add_line_to_file fish_environment('krew'),
                   "set -x KREW_ROOT #{krew_root}; " \
                   'fish_add_path --global --move --path "$KREW_ROOT/bin"'
  add_line_to_file bash_environment, "export KREW_ROOT=#{krew_root}; " \
                                     '[[ ":$PATH:" =~ ":$KREW_ROOT/bin:" ]] || ' \
                                     'export PATH="${KREW_ROOT}/bin:$PATH"'

  command 'kubectl-krew', 'update'
  command 'kubectl-krew', 'install', 'get-all'
  command 'kubectl-krew', 'install', 'pv-migrate'
  command 'kubectl-krew', 'install', 'openebs'
  command 'kubectl-krew', 'install', 'rook-ceph'
end
