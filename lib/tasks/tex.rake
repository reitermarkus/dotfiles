task :tex => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Updating TeX packages …' }
  command sudo, 'tlmgr', 'update', '--all', '--self'
end
