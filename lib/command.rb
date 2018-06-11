require 'English'
require 'open3'
require 'pty'

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

class IO
  def readline_nonblock(sep = $INPUT_RECORD_SEPARATOR)
    line = ''
    buffer = ''

    loop do
      break if buffer == sep
      read_nonblock(1, buffer)
      line.concat(buffer)
    end

    line
  rescue IO::WaitReadable, EOFError => e
    raise e if line.empty?
    line
  end
end

def command(*args, silent: false, tries: 1, input: '', **opts)
  args = args.flatten(1)

  popen(*args, stdout_tty: true, stderr_tty: true, **opts) { |stdin, stdout, stderr, thread|
    out = ''
    err = ''
    merged = ''

    stdin.print input
    stdin.close_write

    loop do
      readers, = IO.select([stdout, stderr])

      break if readers.all?(&:eof?)

      readers.reject(&:eof?).each do |reader|
        begin
          line = reader.readline_nonblock

          merged << line

          case reader
          when stdout
            out << line
            $stdout.write line unless silent
          when stderr
            line = reader.readline
            err << line
            $stderr.write line unless silent
          end
        rescue IO::WaitReadable, EOFError
          next
        end
      end
    end

    stdout.close_read
    stderr.close_read

    status = thread.value

    raise NonZeroExit.new(*args, err, status) unless status.success?

    [out, err, merged, status]
  }
rescue
  tries -= 1
  retry if tries > 0
  raise
end

def capture(*args, **opts)
  out, = command(*args, silent: true, stdout_tty: false, **opts)
  out
end

def sudo
  askpass_flag = ENV.key?('SUDO_ASKPASS') ? '-A' : nil
  ['/usr/bin/sudo', *askpass_flag, '-E', '--']
end
