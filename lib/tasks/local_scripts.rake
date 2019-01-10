# frozen_string_literal: true

task :local_scripts do
  local_dotfiles = File.expand_path('~/Library/Scripts/local-dotfiles.sh')

  next unless File.exist?(local_dotfiles)

  puts ANSI.blue { 'Running local scripts …' }
  command '/bin/sh', local_dotfiles
end
