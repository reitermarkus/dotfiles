require 'add_login_item'
require 'pathname'
require 'base64'

namespace :dropbox do
  DROPBOX_DIR = Pathname('~/Dropbox')

  task :all => [:init, :login_item]

  task :init do
    DROPBOX_DIR.expand_path.mkpath

    host_db = Pathname('~/.dropbox/host.db')

    host_db.dirname.mkpath

    host_db.expand_path.open('w') do |f|
      f.puts '0' * 40
      f.puts Base64.encode64(DROPBOX_DIR.expand_path.to_s)
    end
  end

  task :login_item do
    add_login_item 'com.getdropbox.dropbox', hidden: true
  end
end
