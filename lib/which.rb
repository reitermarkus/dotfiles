# frozen_string_literal: true

def which(executable)
  ENV['PATH']
    .split(File::PATH_SEPARATOR)
    .map { |p| "#{p}/#{executable}" }
    .detect { |p| File.executable?(p) }
end
