# frozen_string_literal: true

require 'defaults'

task :transmission do
  defaults 'org.m0k.transmission' do
    write 'AutoSize', true
    write 'CheckQuitDownloading', true
    write 'CheckRemoveDownloading', true
    write 'DeleteOriginalTorrent', true
    write 'DownloadAskManual', true
    write 'DownloadAskMulti', true
    write 'RenamePartialFiles', true
    write 'WarningDonate', false
    write 'WarningLegal', false
  end
end
