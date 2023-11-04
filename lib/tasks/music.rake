# frozen_string_literal: true

task :music do
  defaults 'com.apple.Music' do
    write 'firstLaunchShowWelcomeScreenState', 2
    write 'showWelcomeScreenState', 2
    write 'checkForAvailableDownloads', true
    write 'hasShownFirstLoveDialog', true
    write 'downloadDolbyAtmos', true
    write 'dontWarnAboutRequiringExternalHardware', true
    write 'losslessEnabled', true
    write 'preferredDownloadAudioQuality', 20
    write 'preferredStreamPlaybackAudioQuality', 20
    write 'showStatusBar', true
    write 'automaticallyDownloadArtwork', true
    write 'checkForAvailableDownloads', true
  end
end
