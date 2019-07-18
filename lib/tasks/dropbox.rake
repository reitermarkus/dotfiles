# frozen_string_literal: true

require 'add_login_item'
require 'pathname'
require 'base64'
require 'json'

task :dropbox => [:'dropbox:init', :'dropbox:login_item']

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
      f.puts JSON.generate({ tag: :dropbox, ns: 2937623 })
    end
  end

  desc 'Add Dropbox Login Item'
  task :login_item => [:'brew:casks_and_formulae'] do
    add_login_item 'com.getdropbox.dropbox', hidden: true
  end
end
