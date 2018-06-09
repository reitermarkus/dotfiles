def which(executable)
  ENV['PATH']
    .split(File::PATH_SEPARATOR)
    .any? { |p| File.executable?("#{p}/#{executable}") }
end
