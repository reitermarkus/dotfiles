# frozen_string_literal: true

require 'environment'
require 'add_line_to_file'

task :krew => :fish do
  krew_root = '~/.config/krew'

  ENV['KREW_ROOT'] = File.expand_path(krew_root)
  ENV['PATH'] = "#{ENV['KREW_ROOT']}/bin:#{ENV['PATH']}"

  add_line_to_file fish_environment, "set -x KREW_ROOT #{krew_root}; " \
                                     'contains "$KREW_ROOT/bin" $PATH; ' \
                                     'or set -x fish_user_paths "$KREW_ROOT/bin" $fish_user_paths'
  add_line_to_file bash_environment, "export KREW_ROOT=#{krew_root}; " \
                                     '[[ ":$PATH:" =~ ":$KREW_ROOT/bin:" ]] || ' \
                                     'export PATH="${KREW_ROOT}/bin:$PATH"'

  command 'kubectl-krew', 'update'
  command 'kubectl-krew', 'install', 'get-all'
  command 'kubectl-krew', 'install', 'pv-migrate'
  command 'kubectl-krew', 'install', 'openebs'
end
