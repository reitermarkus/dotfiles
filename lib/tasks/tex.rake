task :tex do
  if tlmgr = (which 'tlmgr')
    puts ANSI.blue { 'Updating TeX packages …' }
    command sudo, tlmgr, 'update', '--all', '--self'
  end
end
