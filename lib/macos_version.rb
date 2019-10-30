# frozen_string_literal: true

require 'command'
require 'rubygems'

def macos_version
  @macos_version ||= Gem::Version.new(capture('sw_vers', '-productVersion'))
end
