require 'command'

def add_login_item(bundle_id, hidden: false)
  path = capture('/usr/bin/mdfind', '-onlyin', '/', "kMDItemCFBundleIdentifier=='#{bundle_id}'").lines.first&.strip

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
