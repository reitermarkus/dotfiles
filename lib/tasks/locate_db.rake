# frozen_string_literal: true

task :locate_db do
  begin
    capture sudo, '/bin/launchctl', 'list', 'com.apple.locate'
    puts ANSI.green { 'Locate DB already enabled.' }
  rescue NonZeroExit
    puts ANSI.blue { 'Enabling Locate DB …' }
    capture sudo, '/bin/launchctl', 'load', '-w', '/System/Library/LaunchDaemons/com.apple.locate.plist'
  end
end
