# frozen_string_literal: true

require 'shellwords'

def fish_environment
  File.expand_path('~/.config/fish/conf.d/00-env.fish')
end

def bash_environment
  File.expand_path('~/.bashrc')
end
