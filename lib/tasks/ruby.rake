# frozen_string_literal: true

require 'defaults'

task :ruby do
  puts ANSI.blue { 'Configuring Ruby …' }

  if capture('gem', 'list', '--no-versions', 'bundler').strip == 'bundler'
    puts ANSI.green { 'Bundler is already installed.' }
  else
    puts ANSI.blue { 'Installing Bundler …' }
    command 'gem', 'install', 'bundler'
  end

  command 'bundle', 'config', '--global', 'bin', '.bundle/bin'

  processors = capture('/usr/sbin/sysctl', '-n', 'hw.ncpu').strip
  puts ANSI.blue { "Configuring Bundler with #{processors} processors …" }
  command 'bundle', 'config', '--global', 'jobs', processors
end
