# frozen_string_literal: true

task :tex => [:'brew:casks_and_formulae'] do
  next if ci?

  puts ANSI.blue { 'Updating TeX packages …' }
  command sudo, 'tlmgr', 'update', '--all', '--self'
end
