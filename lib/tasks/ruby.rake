require 'defaults'

task :ruby => [:'ruby:rbenv', :'ruby:bundler']

namespace :ruby do
  task :bundler => [:'bundler:install', :'bundler:config']

  namespace :bundler do
    task :install => [:'ruby:rbenv'] do
      if capture('gem', 'list', '--no-versions', 'bundler').strip == 'bundler'
        puts ANSI.green { 'Bundler is already installed.' }
      else
        puts ANSI.green { 'Installing Bundler …' }
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

  task :rbenv => [:'brew:casks_and_formulae'] do
    rbenv_root = '~/.config/rbenv'

    ENV['RBENV_ROOT'] = File.expand_path(rbenv_root)
    ENV['PATH'] = "#{ENV['RBENV_ROOT']}/shims:#{ENV['PATH']}"

    command 'rbenv', 'rehash'

    add_line_to_file fish_environment, "set -x RBENV_ROOT #{rbenv_root}"
    capture 'fish', '-c', 'fisher', 'install', 'rbenv'

    add_line_to_file bash_environment, "export RBENV_ROOT=#{rbenv_root}"
    add_line_to_file bash_environment, 'eval "$(rbenv init -)"'

    defaults 'com.macromates.TextMate' do
      write 'environmentVariables', [
        {
          'enabled' => true,
          'name' => 'RBENV_ROOT',
          'value' => ENV['RBENV_ROOT'],
        },
        {
          'enabled' => true,
          'name' => 'PATH',
          'value' => '$RBENV_ROOT/shims:$PATH',
        },
      ], add: true
    end
  end
end
