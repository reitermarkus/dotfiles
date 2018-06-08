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

require 'open3'

class CommandError < RuntimeError
  def initialize(command, stderr, status)
    super "'#{command.join(' ')}'".concat(" exited with #{status.exitstatus}\n").concat(stderr)
  end
end

require 'shellwords'

def `(string)
  args = string.shellsplit
  stdout, = run!(*args)
  stdout
end

def run(*args)
  Open3.capture3(*args)
end

def run!(*args)
  stdout, stderr, status = run(*args)
  raise CommandError.new(args, stderr, status) unless status.success?
  [stdout, stderr, status]
end

def which(executable)
  ENV['PATH'].split(':').any? { |p| File.executable?("#{p}/#{executable}") }
end

def system(*args)
  pid = Process.spawn(*args, in: $stdin, out: $stdout, err: $stderr)
  _, status = Process.wait2(pid)
  raise CommandError.new(args, '', status) unless status.success?
end

def ci?
  ENV.key?('CI')
end
