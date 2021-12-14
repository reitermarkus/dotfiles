# frozen_string_literal: true

require 'command'

def path_by_bundle_id(bundle_id)
  capture('/usr/bin/mdfind', '-onlyin', '/', "kMDItemCFBundleIdentifier=='#{bundle_id}'").lines.first&.strip
end

def add_login_item(bundle_id, hidden: false)
  return if ci?

  path = path_by_bundle_id(bundle_id)

  script = <<~JAVASCRIPT
    'use strict';

    ObjC.import('stdlib')

    var systemEvents = Application('System Events')

    systemEvents.loginItems.push(systemEvents.LoginItem({
      path: '#{path}',
      hidden: #{hidden}
    }))

    $.exit(0)
  JAVASCRIPT

  command '/usr/bin/osascript', '-l', 'JavaScript', *script.lines.flat_map { |line| ['-e', line] }
end

def remove_login_item(bundle_id)
  return if ci?

  path = path_by_bundle_id(bundle_id)

  login_item_exists = begin
    capture(
      '/usr/bin/osascript', '-e',
      "tell application \"System Events\" to get the path of every login item contains \"#{path}\"",
    ).strip == 'true'
  rescue NonZeroExit
    false
  end

  return unless login_item_exists

  command '/usr/bin/osascript', '-e', "tell application \"System Events\" to delete login item {path:\"#{path}\"}"
end
