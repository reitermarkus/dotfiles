require 'shellwords'

require 'add_line_to_file'

def fish_environment
  File.expand_path('~/.config/fish/conf.d/__env.fish')
end

def bash_environment
  File.expand_path('~/.bashrc')
end
