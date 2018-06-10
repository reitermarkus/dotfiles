require 'concurrent'
require 'command'

namespace :screensaver do
  task :apple_tv do
    puts 'Downloading Apple TV Screen Savers …'

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
        puts "Downloading #{filename} …"
      }.then(executor: download_pool) {
        command '/usr/bin/curl', '--silent', '--continue-at', '-', '--location', video['url'], '-o', download_path
      }.then(executor: serial_executor) {
        puts "Downloaded #{filename}."
      }
    }

    promises.each(&:wait!)
  end
end
