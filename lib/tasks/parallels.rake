# frozen_string_literal: true

task :parallels do
  virtual_machines_dir = File.expand_path('~/Virtual Machines.localized')

  defaults 'com.parallels.Parallels Desktop' do
    write 'FileDevSelectorWidget.FolderHistoryItem·0', virtual_machines_dir
  end

  FileUtils.mkdir_p "#{virtual_machines_dir}/.localized"

  File.write "#{virtual_machines_dir}/.localized/de.strings", <<~STRINGS
    "Virtual Machines" = "Virtuelle Maschinen";
  STRINGS

  File.write "#{virtual_machines_dir}/.localized/en.strings", <<~STRINGS
    "Virtual Machines" = "Virtual Machines";
  STRINGS
end
