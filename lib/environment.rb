require 'shellwords'

require 'add_line_to_file'

def fish_environment
  File.expand_path('~/.config/fish/conf.d/environment')
end

def bash_environment
  File.expand_path('~/.bashrc')
end
