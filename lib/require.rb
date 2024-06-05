# frozen_string_literal: true

require 'fileutils'
require 'rubygems/commands/install_command'
require 'tempfile'

def silently
  old_stdout = $stdout.dup
  old_stderr = $stderr.dup
  $stdout.reopen(File::NULL)
  $stderr.reopen(File::NULL)
  yield
ensure
  $stdout.reopen(old_stdout)
  $stderr.reopen(old_stderr)
end

def require(name)
  super
rescue LoadError => e
  begin
    install_gem name
  rescue StandardError => err
    $stderr.puts err.message if ci?
    raise e
  end

  super
end

AUTO_INSTALLED_GEMS = %w[
  ansi
  concurrent-ruby
  concurrent-ruby-ext
  iniparse
  plist
  vdf
].freeze

def install_gem(name, version = nil)
  raise unless AUTO_INSTALLED_GEMS.include?(name)

  if name == 'concurrent'
    unless Gem.win_platform?
      begin
        install_gem 'concurrent-ruby-ext'
      rescue StandardError
        # Allow to fail when Xcode Command Line Tools are missing.
      end
    end
    name = 'concurrent-ruby'
  end

  begin
    saved_env = ENV.to_hash

    ENV['GEM_PATH'] = ENV['GEM_HOME'] = '/tmp/dotfiles-gem-home'

    Gem.clear_paths
    Gem::Specification.reset

    return unless Gem::Specification.find_all_by_name(name, version).empty?

    # Do `gem install [...]` without having to spawn a separate process or
    # having to find the right `gem` binary for the running Ruby interpreter.
    Gem::Commands::InstallCommand.new.tap do |cmd|
      install_args = [name, '--no-document']
      install_args += ['--version', version] unless version.nil?

      cmd.handle_options(install_args)

      silently do
        cmd.execute
      end
    end
  ensure
    ENV.replace(saved_env)
  end
rescue Gem::SystemExitException => e
  raise e.message if e.exit_code.nonzero?
end
