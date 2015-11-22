#!/usr/bin/python
# -*- coding: utf-8 -*-


import os, sys, json, time, urllib


# Unicode Characters
elipsis = unichr(0x2026)


def fetch_json(app_ids):

  url = 'https://itunes.apple.com/lookup?id=%s' % app_ids[0]

  # Append additional IDs to URL.
  for app_id in app_ids[1:]:
    url = '%s,%s' % (url,app_id)

  response = urllib.urlopen(url)
  data = json.loads(response.read())

  return data['results']


def is_app_installed(bundle_id):

  # Shell exits with 0 if app is found, so this has to be negated.
  return not os.system('mdfind -onlyin /Applications kMDItemCFBundleIdentifier==%s | grep --quiet .app' % bundle_id)


def is_app_downloading(name):

  # Returns true if *.appdownload path exists.
  return os.path.exists('/Applications/%s.appdownload' % name)


def click_install_button():

  # Shell exits with 0 if click was successful, so this has to be negated.
  return not os.system('osascript -e \'tell application "System Events" to tell application process "App Store" to tell window 1 to tell group 1 to tell group 1 to tell scroll area 1 to tell UI element 1 to tell group 1 to tell group 1 to if description of button 1 contains "Install" then click button 1\' &>/dev/null')


def open_appstore(mas_url='macappstore://showUpdatesPage'):

  # Open App Store with URL
  os.system('open -gj "%s" &>/dev/null' % mas_url)


def close_appstore():

  # Kill App Store silently.
  os.system('killall "App Store" &>/dev/null')


def install_app(name, bundle_id, mas_url):

  if is_app_installed(bundle_id):
    print('%s is already installed.' % name)
  else:

    close_appstore()

    print('Opening %s in App Store %s' % (name, elipsis))

    open_appstore(mas_url)

    print('Installing %s from App Store %s' % (name, elipsis))

    timeout = time.time() + 30
    while not (is_app_downloading(name) or is_app_installed(bundle_id)) and time.time() < timeout:
      click_install_button()
      time.sleep(1)

    if is_app_downloading(name):
      print('%s is downloading %s' % (name, elipsis))
    elif is_app_installed(bundle_id):
      print('%s installed.' % name)
    else:
      print('Error installing %s.' % name)

    close_appstore()


def install_apps(apps):

  for app in fetch_json(apps):

    name = app['trackName']
    bundle_id = app['bundleId']
    mas_url = 'macappstore://itunes.apple.com/app/id%s' % app['trackId']

    install_app(name, bundle_id, mas_url)


def main():

  install_apps(sys.argv[1:])


if __name__ == '__main__':
  main()
