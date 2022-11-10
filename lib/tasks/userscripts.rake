task :userscripts => :files do
  icloud_scripts_dir = Pathname('~/Library/Mobile Documents/com~apple~CloudDocs/com.userscripts.macos.Userscripts-Extension/Data/Documents/scripts').expand_path
  icloud_scripts_dir.dirname.mkpath

  defaults 'com.userscripts.macos' do
    write 'NSNavLastRootDirectory', icloud_scripts_dir.to_path
  end
end
