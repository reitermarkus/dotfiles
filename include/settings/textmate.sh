#!/bin/sh


# TextMate Defaults

defaults_textmate() {

  # Ensure that Ruby 1.8 is downloaded.
  /bin/mkdir -p ~/Library/Application\ Support/TextMate/Ruby
  /usr/bin/curl -fsSL http://archive.textmate.org/ruby/ruby_1.8.7.tbz | \
    /usr/bin/tar xz -m -C ~/Library/Application\ Support/TextMate/Ruby

  /usr/bin/defaults write com.macromates.TextMate environmentVariables -array \
    """
      <dict>
        <key>enabled</key><true/>
        <key>name</key><string>RBENV_ROOT</string>
        <key>value</key><string>$RBENV_ROOT</string>
      </dict>
    """ \
    """
      <dict>
        <key>enabled</key><true/>
        <key>name</key><string>PATH</string>
        <key>value</key><string>\$RBENV_ROOT/shims:\$PATH:/usr/local/bin</string>
      </dict>
    """

  /usr/bin/killall cfprefsd &>/dev/null

}
