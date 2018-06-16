class Pathname
  def recurse(&block)
    each_child do |child|
      yield child
      child.recurse(&block) if child.directory?
    end
  end

  def files
    files = []

    recurse do |child|
      next if child.directory?
      files << child
    end

    files
  end
end

task :files do
  puts ANSI.blue { "Copying files …" }
  Pathname("#{DOTFILES_DIR}/~").files.each do |path|
    relative_path = path.relative_path_from(Pathname(DOTFILES_DIR))
    user_path = relative_path.expand_path
    user_path.dirname.mkpath
    puts relative_path
    FileUtils.cp path, user_path
  end
end
