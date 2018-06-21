require 'add_line_to_file'

task :bash => [:'brew:casks_and_formulae'] do
  add_line_to_file '/etc/shells', (which 'bash')

  add_line_to_file '~/.bash_profile', 'test -f ~/.bashrc && source ~/.bashrc'
  add_line_to_file '~/.bash_profile', 'test -f ~/.profile && source ~/.profile'

  # Import Bash Completion into ~/.bashrc
  add_line_to_file '~/.bashrc', 'test -f /etc/bashrc && source /etc/bashrc'
  add_line_to_file '~/.bashrc', 'brew list bash-completion &>/dev/null && source "$(brew --prefix)/etc/bash_completion"'
end
