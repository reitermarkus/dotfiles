# frozen_string_literal: true

$LOAD_PATH.unshift 'lib'

require 'require'
require 'ci'

Rake.add_rakelib 'lib/tasks'

require 'concurrent-edge'
require 'ansi'

module Rake
  class Task
    module Travis
      def execute(*)
        return super if @actions.empty?

        travis_fold_id = name.tr(':', '.')
        travis_timer_id = rand(2**32).to_s(16)

        puts "travis_fold:start:#{travis_fold_id}"
        puts "travis_time:start:#{travis_timer_id}"

        start_time = Time.now

        begin
          super
        ensure
          end_time = Time.now

          travis_start_time = (start_time.to_f * 1_000_000_000).to_i
          travis_end_time = (end_time.to_f * 1_000_000_000).to_i
          travis_duration = travis_end_time - travis_start_time

          puts "travis_time:end:#{travis_timer_id},start=#{travis_start_time},finish=#{travis_end_time},duration=#{travis_duration}"
          puts "travis_fold:end:#{travis_fold_id}"
        end
      end
    end

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
    prepend Travis if travis?
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
