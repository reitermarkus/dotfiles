require 'command'

def laptop?
  capture('/usr/sbin/ioreg', '-c', 'IOPlatformExpertDevice', '-r', '-d', '1')
    .include?('MacBook')
end
