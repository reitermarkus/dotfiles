# frozen_string_literal: true

require 'rbconfig'

def macos?
  RbConfig::CONFIG['host_os'].match?(/darwin|mac os/i)
end
