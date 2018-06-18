require 'concurrent'
require 'command'

task :screensaver => [:'screensaver:defaults', :'screensaver:apple_tv', :'screensaver:savehollywood']

namespace :screensaver do
  task :defaults do
    puts ANSI.blue { 'Configuring screensaver settings …' }

    defaults 'com.apple.screensaver' do
      # Ask for password after screensaver.
      write 'askForPassword', true

      # Set password delay.
      write 'askForPasswordDelay', laptop? ? 60 : 300
    end

    defaults current_host: 'com.apple.screensaver' do
      # Set screensaver delay.
      write 'idleTime', laptop? ? 120 : 300

      # Don't show Clock on Screensaver
      write 'showClock', false
    end

    capture '/usr/bin/killall', 'cfprefsd'
    capture '/usr/bin/killall', '-HUP', 'Dock'
  end

  task :apple_tv do
    puts ANSI.blue { 'Downloading Apple TV Screen Savers …' }

    VIDEOS_JSON_URL = URI('http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/entries.json')

    response = Net::HTTP.get(VIDEOS_JSON_URL)
    json = JSON.parse(response)

    duplicates = Set.new

    download_pool = Concurrent::FixedThreadPool.new(10)

    promises = json.map { |video_set|
      Concurrent::Promise.execute(executor: download_pool) {
        video_set['assets'].map { |video|
          url = URI(video['url'])

          url = Net::HTTP.start(url.hostname) { |http|
            URI(http.head(url.path)['location'])
          }

          size = Net::HTTP.start(url.hostname) { |http|
            head = http.head(url.path)
            head['content-length'].to_i
          }

          video['url'] = url.to_s
          video['size'] = size

          video
        }
      }
    }

    videos = promises.flat_map(&:value!)
                     .select { |video| duplicates.add?(video['size']) }

    download_dir = Pathname('~/Library/Screen Savers/Videos').expand_path
    download_dir.mkpath

    serial_executor = Concurrent::SingleThreadExecutor.new

    promises = videos.map { |video|
      filename = video['accessibilityLabel']
                   .concat('.').concat(video['timeOfDay'])
                   .concat('.').concat(video['id'])
                   .concat(File.extname(video['url']))

      download_path = File.join(download_dir, filename)

      if File.exist?(download_path) && video['size'] == File.size(download_path)
        next Concurrent::Promise.fulfill(nil)
      end

      Concurrent::Promise.execute(executor: serial_executor) {
        puts ANSI.blue { "Downloading #{filename} …" }
      }.then(executor: download_pool) {
        command '/usr/bin/curl', '--silent', '--continue-at', '-', '--location', video['url'], '-o', download_path
      }.then(executor: serial_executor) {
        puts ANSI.green { "Downloaded #{filename}." }
      }
    }

    promises.each(&:wait!)
  end

  task :savehollywood => [:'brew:casks_and_formulae'] do
    defaults current_host: 'fr.whitebox.SaveHollywood' do
      write 'assets.library', [File.expand_path('~/Library/Screen Savers/Videos')]
      write 'assets.randomOrder', true
      write 'assets.startWhereLeftOff', false
      write 'frame.drawBorder', false
      write 'frame.randomPosition', false
      write 'frame.scaling', 1
      write 'frame.showMetadata.mode', false
      write 'movie.volume.mode', 1
      write 'screen.mainDisplayOnly', false
    end

    path = capture('/usr/bin/mdfind', '-onlyin', '/', 'kMDItemCFBundleIdentifier=="fr.whitebox.SaveHollywood"').lines.first&.strip

    defaults current_host: 'com.apple.screensaver' do
      if path
        write 'moduleDict', {
          'moduleName' => 'SaveHollywood',
          'path' => path,
          'type' => 0,
        }
      else
        write 'moduleDict', {
          'moduleName' => 'Arabesque',
          'path' => '/System/Library/Screen Savers/Arabesque.qtz',
          'type' => 1,
        }
      end
    end
  end
end
