$LOAD_PATH.unshift "#{__dir__}/lib"

require 'require'


Rake.add_rakelib 'lib/tasks'

require 'concurrent-edge'
require 'pty'

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

class NonZeroExit < RuntimeError
  attr_reader :command, :stderr, :status

  def initialize(*command, stderr, status)
    @command = command.join(' ')
    @stderr = stderr
    @status = status
  end

  def message
    message = "'#{command}' exited with #{status.exitstatus}"
    message.concat("\n#{stderr}") unless stderr.empty?
    message
  end
end

def which(executable)
  ENV['PATH'].split(':').any? { |p| File.executable?("#{p}/#{executable}") }
end

def ci?
  ENV.key?('CI')
end

def popen(*args, stdout_tty: false, stderr_tty: false, **opts, &block)
  in_r, in_w = IO.pipe
  opts[:in] = in_r
  in_w.sync = true

  out_r, out_w = stdout_tty ? PTY.open : IO.pipe
  opts[:out] = out_w

  err_r, err_w = stderr_tty ? PTY.open : IO.pipe
  opts[:err] = err_w

  parent_io = [in_w, out_r, err_r]
  child_io = [in_r, out_w, err_w]

  pid = Process.spawn(*args, **opts)
  wait_thr = Process.detach(pid)
  child_io.each(&:close)

  result = [*parent_io, wait_thr]

  if block_given?
    begin
      return yield(*result)
    ensure
      parent_io.each(&:close)
      wait_thr.join
    end
  end

  result
end

def command(*args, silent: false, **opts)
  args = args.flatten(1)

  popen(*args, stdout_tty: true, stderr_tty: true, **opts) { |stdin, stdout, stderr, thread|
    out = ''
    err = ''
    merged = ''

    stdin.close

    loop do
      readers, writers = IO.select([stdout, stderr])

      if (reader = readers.first) && !reader.eof?
        case reader
        when stdout
          line = reader.readline
          out << line
          merged << line
          $stdout.write line unless silent
        when stderr
          line = reader.readline
          err << line
          merged << line
          $stderr.write line unless silent
        end
      end

      break if stdout.eof? && stderr.eof?
    end

    stdout.close
    stderr.close

    status = thread.value

    raise NonZeroExit.new(*args, err, status) unless status.success?

    [out, err, merged, status]
  }
end

def capture(*cmd, **opts)
  out, = command(*cmd, silent: true, stdout_tty: false, **opts)
  out
end

def sudo
  askpass_flag = ENV.key?('SUDO_ASKPASS') ? '-A' : nil
  ['/usr/bin/sudo', *askpass_flag, '-E', '--']
end
