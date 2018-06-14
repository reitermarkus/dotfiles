task :tower do
  defaults 'com.fournova.Tower2' do
    write 'GTUserDefaultsGitBinary', which('git')
  end
end
