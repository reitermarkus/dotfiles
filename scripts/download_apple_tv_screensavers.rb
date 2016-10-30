#!/usr/bin/ruby

require 'fileutils'
require 'json'
require 'net/http'
require 'set'
require 'thread'
require 'uri'

class AppleTVScreenSavers
  VIDEOS_JSON_URL = URI('http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/entries.json')

  def initialize(download_dir)
    @download_dir = File.expand_path(download_dir)
  end

  def fetch_json
    response = Net::HTTP.get(VIDEOS_JSON_URL)
    JSON.parse(response)
  end

  def videos
    duplicates = Set.new

    fetch_json.flat_map { |video_set|
      video_set['assets'].select { |video|
        url = URI(video['url'])

        video['url'] = Net::HTTP.start(url.hostname) { |http|
          URI(http.head(url.path)['location'])
        }

        head = Net::HTTP.start(video['url'].hostname) { |http|
          http.head(video['url'].path)
        }

        next if duplicates.add?(head['content-length']).nil?

        video
      }
    }
  end

  def download
    FileUtils.mkdir_p(@download_dir)

    queue = Queue.new

    videos.each do |video|
      queue.enq(video)
    end

    mutex = Mutex.new

    threads = 4.times.map {
      Thread.new do
        Kernel.loop do
          break if queue.empty?

          video = queue.deq

          filename = video['accessibilityLabel']
                       .concat('.').concat(video['timeOfDay'])
                       .concat('.').concat(video['id'])
                       .concat(File.extname(video['url'].path))

          download_path = File.join(@download_dir, filename)

          mutex.synchronize {
            puts "Downloading #{filename} …"
          }

          system '/usr/bin/curl', '--silent', '--continue-at', '-', '--location', video['url'].to_s, '-o', download_path

          mutex.synchronize {
            puts "Downloaded #{filename}."
          }
        end
      end
    }

    threads.each(&:join)
  end
end

if (dir = ARGV.first).nil?
  raise ArgumentError, "Must specify download directory."
end

AppleTVScreenSavers.new(dir).download
