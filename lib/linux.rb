# frozen_string_literal: true

require 'rbconfig'

def linux?
  RbConfig::CONFIG['host_os'].match?(/linux/i)
end
