# frozen_string_literal: true

task :userscripts => :files do
  icloud_dir = Pathname('~/Library/Mobile Documents/com~apple~CloudDocs').expand_path
  icloud_scripts_dir = icloud_dir.join('com.userscripts.macos.Userscripts-Extension/Data/Documents/scripts')
  icloud_scripts_dir.dirname.mkpath

  defaults 'com.userscripts.macos' do
    write 'NSNavLastRootDirectory', icloud_scripts_dir.to_path
  end
end
