# frozen_string_literal: true

require 'command'

def killall(process_name, signal: nil)
  signal = signal ? "-#{signal}" : nil
  capture '/usr/bin/killall', *signal, process_name
rescue NonZeroExit => e
  raise unless e.stderr.match?(/No matching processes/i)
end
