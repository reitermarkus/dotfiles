def add_line_to_file(file, line)
  file = File.expand_path(file)

  if File.exist?(file)
    lines = File.readlines(file).map(&:strip)
    return if lines.include?(line)
  else
    FileUtils.mkdir_p File.dirname(file)
    FileUtils.touch file
  end

  if File.writable?(file)
    File.open(file, 'a') do |f|
      f.puts line
    end
  else
    capture sudo, '/usr/bin/tee', '-a', '/etc/shells', input: "#{line}\n"
  end
end
