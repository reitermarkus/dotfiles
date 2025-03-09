# frozen_string_literal: true

require 'shellwords'

def fish_environment(suffix = nil)
  suffix = suffix ? "-#{suffix}" : ''
  File.expand_path("~/.config/fish/conf.d/00-env#{suffix}.fish")
end

def bash_environment
  File.expand_path('~/.bashrc')
end
