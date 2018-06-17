require 'add_login_item'
require 'pathname'
require 'base64'
require 'json'

task :dropbox => [:'dropbox:init', :'dropbox:login_item', :'dropbox:link_directories']

namespace :dropbox do
  DROPBOX_DIR = Pathname('~/Dropbox')

  desc 'Initialize Dropbox Directory'
  task :init do
    DROPBOX_DIR.expand_path.mkpath

    host_db = Pathname('~/.dropbox/host.db').expand_path

    host_db.dirname.mkpath

    host_db.open('w') do |f|
      f.puts '0' * 40
      f.puts Base64.encode64(DROPBOX_DIR.expand_path.to_s)
    end

    DROPBOX_DIR.join('.dropbox').expand_path.open('w') do |f|
      f.puts JSON.generate({tag: :dropbox, ns: 2937623})
    end
  end

  desc 'Add Dropbox Login Item'
  task :login_item do
    add_login_item 'com.getdropbox.dropbox', hidden: true
  end

  desc 'Create Dropbox Symlinks'
  task :link_directories do
    def link_directory(dir)
      local_dirname = "~/#{dir}"
      dropbox_dirname = "#{DROPBOX_DIR}/Sync/~/#{dir}"

      local_dir = Pathname(local_dirname).expand_path
      dropbox_dir = Pathname(dropbox_dirname).expand_path

      if dropbox_dir.symlink?
        puts "#{local_dirname} already linked to Dropbox."
        return
      end

      puts "Linking #{local_dirname} to #{dropbox_dirname} …"

      was_running = begin
        command '/usr/bin/killall', 'Dropbox'
        true
      rescue NonZeroExit
        false
      end

      unless local_dir.directory?
        FileUtils.rm_f local_dir
        local_dir.mkpath
      end

      if dropbox_dir.directory?
        FileUtils.rm_f dropbox_dir.join('.DS_Store')

        dropbox_dir.children.each do |child|
          FileUtils.mv_f child, local_dir
        end

        FileUtils.rmdir dropbox_dir
      else
        FileUtils.rm_f dropbox_dir
      end

      dropbox_dir.dirname.mkpath

      FileUtils.ln_sf local_dir, dropbox_dir

      command '/usr/bin/open', '-gja', 'Dropbox' if was_running
    end

    link_directory 'Desktop'

    link_directory 'Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks'
    link_directory 'Library/Fonts'
    link_directory 'Library/Desktop Pictures'
    link_directory 'Library/User Pictures'

    link_directory 'Documents/Arduino'
    link_directory 'Documents/Backups'
    link_directory 'Documents/Cinquecento'
    link_directory 'Documents/Entwicklung'
    link_directory 'Documents/Fonts'
    link_directory 'Documents/Git-Repos'
    link_directory 'Documents/Projekte'
    link_directory 'Documents/Scans'
    link_directory 'Documents/SketchUp'
    link_directory 'Documents/Sonstiges'
    link_directory 'Documents/Uni'
  end
end
