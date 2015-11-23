#!/usr/bin/python
# -*- coding: utf-8 -*-


import os, sys, json, time, urllib


# Unicode Characters

elipsis = unichr(0x2026)


# Terminal Colors

c_red     = '\033[0;31m'
c_green   = '\033[0;32m'
c_blue    = '\033[0;34m'
c_white   = '\033[0;37m'
c_cyan    = '\033[0;36m'
c_magenta = '\033[0;35m'
c_yellow  = '\033[0;33m'
c_black   = '\033[0;30m'
c_reset   = '\033[0;00m'


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
    print('%s%s is already installed.%s' % (c_green, name, c_reset))
  else:

    close_appstore()

    print('%sOpening %s in App Store %s%s' % (c_blue, name, elipsis, c_reset))

    open_appstore(mas_url)

    print('%sInstalling %s from App Store %s%s' % (c_blue, name, elipsis, c_reset))

    timeout = time.time() + 30
    while not (is_app_downloading(name) or is_app_installed(bundle_id)) and timeout > time.time():
      click_install_button()
      time.sleep(1)

    if is_app_downloading(name):
      print('%s%s is downloading %s%s' % (c_blue, name, elipsis, c_reset))
    elif is_app_installed(bundle_id):
      print('%s%s installed.%s' % (c_green, name, c_reset))
    else:
      print('%sError installing %s.%s' % (c_red, name, c_reset))

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
