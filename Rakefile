$LOAD_PATH.unshift "#{__dir__}/lib"

require 'require'
require 'ci'

Rake.add_rakelib 'lib/tasks'

require 'concurrent-edge'
require 'ansi'

module Concurrent
  class Promise
    prepend Module.new {
      def then(rescuer = nil, executor: @executor, &block)
        super(rescuer, executor, &block)
      end
    }
  end
end

class Rake::Task
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
      return super unless invocation_chain == Rake::InvocationChain::EMPTY

      begin
        @__env = ENV.to_hash

        ENV['PATH'] = ['/etc/paths', *Dir.glob('/etc/paths.d/*')]
          .flat_map { |f| File.read(f).strip.split("\n") }
          .join(File::PATH_SEPARATOR)

        super
      ensure
        ENV.replace(@__env)
      end
    end
  end

  prepend PATH
  prepend Travis if ci?
end

DOTFILES_DIR = __dir__
