task :tower do
  puts ANSI.blue { 'Configuring Tower …' }

  defaults 'com.fournova.Tower2' do
    write 'GTUserDefaultsGitBinary', which('git')
  end
end
