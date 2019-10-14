# frozen_string_literal: true

$LOAD_PATH.unshift 'lib'

require 'require'
require 'ci'

Rake.add_rakelib 'lib/tasks'

require 'concurrent-edge'
require 'ansi'

module Rake
  class Task
    module PATH
      def invoke_with_call_chain(_, invocation_chain)
        current_path = ENV['PATH']&.split(File::PATH_SEPARATOR)
        default_path = ['/etc/paths', *Dir.glob('/etc/paths.d/*')]
                         .flat_map { |f| File.read(f).strip.split("\n") }

        ENV['PATH'] = [*current_path, *default_path].uniq.join(File::PATH_SEPARATOR)

        super
      end
    end

    prepend PATH
  end
end

DOTFILES_DIR = __dir__

ALLOWED_VARIABLES = %w[
  Apple_PubSub_Socket_Render
  CI
  HOME
  LANG
  LOGNAME
  PWD
  SHELL
  SHLVL
  SSH_AUTH_SOCK
  SUDO_ASKPASS
  TERM
  TERM_PROGRAM
  TERM_PROGRAM_VERSION
  TERM_SESSION_ID
  TMPDIR
  USER
  XPC_FLAGS
  XPC_SERVICE_NAME
].freeze

ENV.delete_if { |k, _|
  !ALLOWED_VARIABLES.include?(k)
}
