# frozen_string_literal: true

require 'add_line_to_file'
require 'user'

task :fish => [:'brew:casks_and_formulae'] do
  fish_executable = (which 'fish')

  add_line_to_file '/etc/shells', fish_executable

  if ENV['SHELL'] != fish_executable
    puts ANSI.blue { 'Changing shell to `fish` …' }
    command sudo, '/usr/bin/chsh', '-s', fish_executable, USER
  end

  puts ANSI.blue { 'Installing Fish Plugins …' }
  plugins = %w[
    edc/bass
    franciscolourenco/done
    FabioAntunes/fish-nvm
    reitermarkus/fish_prompt
    jethrokuan/z
  ]
  command 'fish', '-c', "fisher install #{plugins.join(' ')}"

  puts ANSI.blue { 'Updating Fish Plugins …' }
  command 'fish', '-c', 'fisher update'
end
