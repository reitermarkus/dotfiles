require 'command'

namespace :screensaver do
  task :apple_tv do
    VIDEOS_JSON_URL = URI('http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/entries.json')

    response = Net::HTTP.get(VIDEOS_JSON_URL)
    json = JSON.parse(response)

    duplicates = Set.new

    videos = json.flat_map { |video_set|
      video_set['assets'].select { |video|
        url = URI(video['url'])

        video['url'] = Net::HTTP.start(url.hostname) { |http|
          URI(http.head(url.path)['location'])
        }

        Net::HTTP.start(video['url'].hostname) { |http|
          head = http.head(video['url'].path)
          video['size'] = head['content-length'].to_i
        }

        next if duplicates.add?(video['size']).nil?

        video
      }
    }

    download_dir = Pathname('~/Library/Screen Savers/Videos').expand_path
    download_dir.mkpath

    download_pool = Concurrent::FixedThreadPool.new(10)
    serial_executor = Concurrent::SingleThreadExecutor.new

    promises = videos.map { |video|
      filename = video['accessibilityLabel']
                   .concat('.').concat(video['timeOfDay'])
                   .concat('.').concat(video['id'])
                   .concat(File.extname(video['url'].path))

      download_path = File.join(download_dir, filename)

      if File.exist?(download_path) && video['size'] == File.size(download_path)
        next Concurrent::Promise.fulfill(nil)
      end

      Concurrent::Promise.execute(executor: serial_executor) {
        puts "Downloading #{filename} …"
      }.then(executor: download_pool) {
        command '/usr/bin/curl', '--silent', '--continue-at', '-', '--location', video['url'].to_s, '-o', download_path
      }.then(executor: serial_executor) {
        puts "Downloaded #{filename}."
      }
    }

    promises.each(&:wait!)
  end
end
