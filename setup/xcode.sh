#!/bin/sh

xcode-select --install && osascript <<EOF
tell application "System Events" to tell application process "Install Command Line Developer Tools"
	repeat until window 1 exists
		delay 0.1
	end repeat
	
	repeat while window 1 exists
		tell window 1
			button 1
			set buttonName to name of button 1
			if buttonName does not contain "stop" then if buttonName does not contain "cancel" then
				click button 1
			end if
		end tell
		delay 0.1
	end repeat
end tell
EOF
