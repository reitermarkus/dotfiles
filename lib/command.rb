# frozen_string_literal: true

require 'English'
require 'open3'
require 'macos'
require 'windows'
require 'pty' unless windows?

class NonZeroExit < RuntimeError
  attr_reader :command, :stdout, :stderr, :merged_output, :status

  def initialize(*command, stdout, stderr, merged_output, status)
    super()

    @command = command.join(' ')
    @stdout = stdout
    @stderr = stderr
    @merged_output = merged_output
    @status = status
  end

  def message
    message = +"'#{command}' exited with #{status.exitstatus}"
    message.concat("\n#{merged_output}") unless merged_output.empty?
    message
  end
end

def popen(*args, stdout_tty: false, stderr_tty: false, **opts)
  in_r, in_w = IO.pipe
  opts[:in] = in_r
  in_w.sync = true

  out_r, out_w = stdout_tty && macos? ? PTY.open : IO.pipe
  opts[:out] = out_w

  err_r, err_w = stderr_tty && macos? ? PTY.open : IO.pipe
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
    line = +''
    buffer = +''

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
    out = +''
    err = +''
    merged = +''

    stdin.print input
    stdin.close_write

    signal = catch(:kill) {
      loop do
        readers, = IO.select([stdout, stderr])

        break if readers.all?(&:eof?)

        readers.reject(&:eof?).each do |reader|
          line = reader.readline_nonblock

          merged << line

          case reader
          when stdout
            out << line
            yield [:stdout, line] if block_given?
            $stdout.write line unless silent
          when stderr
            err << line
            yield [:stderr, line] if block_given?
            $stderr.write line unless silent
          end
        rescue IO::WaitReadable, EOFError
          next
        end
      end

      nil
    }

    if signal
      begin
        Process.kill(signal, thread.pid)
      rescue Errno::ESRCH
        # Ignore already killed process.
      end
    end

    stdout.close_read
    stderr.close_read

    status = thread.value

    raise NonZeroExit.new(*args, out, err, merged, status) if signal.nil? && !status.success?

    [out, err, merged, status]
  }
rescue NonZeroExit
  tries -= 1
  tries.zero? ? raise : retry
end

def capture(*args, **opts)
  out, = command(*args, silent: true, stdout_tty: false, **opts)
  out
end

def sudo
  askpass_flag = ENV.key?('SUDO_ASKPASS') ? '-A' : nil
  ['/usr/bin/sudo', *askpass_flag, '-E', '--']
end
