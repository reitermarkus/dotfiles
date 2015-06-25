if [ ! -d /Applications/Xcode.app ]; then

  open -gj -a 'App Store' macappstore://itunes.apple.com/app/xcode/id497799835


  XCODE_INSTALLED=`osascript <<EOF
  tell application "System Events"
	
    tell application process "App Store"
		
      repeat 100 times
        if button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 exists then
          if description of button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 is equal to "Install, Xcode, Free" then
            click button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
            return true
          end if
        else
          delay 0.2
        end if
      end repeat

      tell application "App Store" to quit
      return false
	
    end tell
  end tell
  EOF`

  if [ "$XCODE_INSTALLED" == "false" ]; then
    cecho 'Error installing Xcode.' $red
  else
    cecho 'Installing Xcode …' $blue
  fi

else
  cecho 'Xcode already installed.' $green
fi
