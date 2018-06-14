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
  rescue
    raise e
  end

  super
end

AUTO_INSTALLED_GEMS = %w[
  ansi
  concurrent-edge
  concurrent-ruby-ext
  concurrent-ruby-edge
  plist
]

def install_gem(name, version = nil)
  raise unless AUTO_INSTALLED_GEMS.include?(name)

  if name == 'concurrent-edge'
    begin
      install_gem 'concurrent-ruby-ext'
    rescue
      # Allow to fail when Xcode Command Line Tools are missing.
    end
    name = 'concurrent-ruby-edge'
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
      install_args = ['--no-ri', '--no-rdoc', name]
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
