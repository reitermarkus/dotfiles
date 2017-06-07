#!/bin/sh


# TextMate Defaults

defaults_textmate() {

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
