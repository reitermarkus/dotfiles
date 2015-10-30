#!/bin/sh


# Grant Assistive Access to Terminal and “osascript”.

enable_assistive_access() {

  echo -b "Enabling Assistive Access …"

  # Notice the digit after the Bundle Identifier (0) and Executable Path (1).

  sudo sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
    "insert or replace into access values('kTCCServiceAccessibility','com.apple.Automator',0,1,1,NULL,NULL);" \
    "insert or replace into access values('kTCCServiceAccessibility','com.apple.ScriptEditor2',0,1,1,NULL,NULL);" \
    "insert or replace into access values('kTCCServiceAccessibility','com.apple.Terminal',0,1,1,NULL,NULL);" \
    "insert or replace into access values('kTCCServiceAccessibility','$(which osascript)',1,1,1,NULL,NULL);" \
  ;

}
