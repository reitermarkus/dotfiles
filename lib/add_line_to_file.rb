def add_line_to_file(file, line)
  file = File.expand_path(file)
  lines = File.open(file, 'r', &:read).lines.map(&:strip)
  return if lines.include?(line)

  if File.writable?(file)
    File.open(file, 'a') do |f|
      f.puts line
    end
  else
    capture sudo, '/usr/bin/tee', '-a', '/etc/shells', input: "#{line}\n"
  end
end
