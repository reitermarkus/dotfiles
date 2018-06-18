task :tex do
  puts ANSI.blue { 'Updating TeX packages …' }
  command sudo, 'tlmgr', 'update', '--all', '--self'
end
