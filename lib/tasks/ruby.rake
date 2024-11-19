# frozen_string_literal: true

require 'defaults'

task :ruby => [:'ruby:bundler']

namespace :ruby do
  task :bundler => [:'bundler:install', :'bundler:config']

  namespace :bundler do
    task :install do
      if capture('gem', 'list', '--no-versions', 'bundler').strip == 'bundler'
        puts ANSI.green { 'Bundler is already installed.' }
      else
        puts ANSI.blue { 'Installing Bundler …' }
        command 'gem', 'install', 'bundler'
      end
    end

    task :config do
      command 'bundle', 'config', '--global', 'bin', '.bundle/bin'

      processors = capture('/usr/sbin/sysctl', '-n', 'hw.ncpu').strip
      puts ANSI.blue { "Configuring Bundler with #{processors} processors …" }
      command 'bundle', 'config', '--global', 'jobs', processors
    end
  end
end
