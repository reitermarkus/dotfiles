#!/usr/bin/python
# -*- coding: utf-8 -*-


import os, json, urllib


def fetch_json():

  url = 'http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/entries.json'

  response = urllib.urlopen(url)
  data = json.loads(response.read())

  return data


def download_videos(download_dir):

  download_dir = os.path.expanduser(download_dir)
  duplicates = []

  if not os.path.exists(download_dir):
    os.makedirs(download_dir)

  for video_set in fetch_json():
    for video in video_set['assets']:

      # Get content length of every video link and check if it was already downloaded.
      response = urllib.urlopen(video['url']).info()['content-length']
      if response not in duplicates:
        duplicates.append(response)

        filename = "%s.%s.%s%s" % (video['accessibilityLabel'], video['timeOfDay'], video['id'], os.path.splitext(video['url'])[-1])
        download_path = "%s/%s" % (download_dir, filename)

        # Download all videos simultaneously via backgrounded “curl” jobs.
        os.system("curl --silent --continue-at - --location '%s' -o '%s' &" % (video['url'], download_path))


def main():

  download_videos('~/Library/Screen Savers/Videos')


if __name__ == '__main__':
  main()
