task :thangs do
  defaults 'com.ThangsSyncClient.app' do
    write 'NSNavLastRootDirectory', '~/Thangs'
  end
end
