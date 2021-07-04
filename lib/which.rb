# frozen_string_literal: true

require 'shellwords'
require 'ci'

def which(executable)
  path = ENV['PATH']
    .split(File::PATH_SEPARATOR)
    .map { |p| "#{p}/#{executable}" }
    .detect { |p| File.executable?(p) }

  $stderr.puts "which(#{executable.inspect}) => #{path.inspect}" if ci?

  path
end
