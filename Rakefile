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

if ci?
  class Rake::Task
    def execute_with_fold(*args)
      if @actions.empty?
        execute_without_fold(*args)
        return
      end

      travis_fold_id = name.tr(':', '.')
      travis_timer_id = rand(2**32).to_s(16)

      puts "travis_fold:start:#{travis_fold_id}"
      puts "travis_time:start:#{travis_timer_id}"

      start_time = Time.now

      begin
        execute_without_fold(*args)
      ensure
        end_time = Time.now

        travis_start_time = (start_time.to_f * 1_000_000_000).to_i
        travis_end_time = (end_time.to_f * 1_000_000_000).to_i
        travis_duration = travis_end_time - travis_start_time

        puts "travis_time:end:#{travis_timer_id},start=#{travis_start_time},finish=#{travis_end_time},duration=#{travis_duration}"
        puts "travis_fold:end:#{travis_fold_id}"
      end
    end

    alias execute_without_fold execute
    alias execute execute_with_fold
  end
end
