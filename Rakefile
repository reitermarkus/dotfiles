$LOAD_PATH.unshift "#{__dir__}/lib"

require 'require'

Rake.add_rakelib 'lib/tasks'

require 'concurrent-edge'

module Concurrent
  class Promise
    prepend Module.new {
      def then(rescuer = nil, executor: @executor, &block)
        super(rescuer, executor, &block)
      end
    }
  end
end
