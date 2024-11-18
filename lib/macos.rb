# frozen_string_literal: true

require 'rbconfig'

def macos?
  RbConfig::CONFIG['host_os'].match?(/darwin|mac os/i)
end

def arm?
  RbConfig::CONFIG['host'].start_with?('aarch64-')
end
