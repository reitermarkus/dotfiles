enable_assistive_access() {

  # Enable Assistive Access
  echo -b "Enabling Assistive Access …"

  # Note the difference between Bundle ID (0) and Path (1).
  sudo /usr/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
    "insert or replace into access values('kTCCServiceAccessibility','com.apple.Automator',0,1,1,NULL,NULL);" \
    "insert or replace into access values('kTCCServiceAccessibility','com.apple.ScriptEditor2',0,1,1,NULL,NULL);" \
    "insert or replace into access values('kTCCServiceAccessibility','com.apple.Terminal',0,1,1,NULL,NULL);" \
    "insert or replace into access values('kTCCServiceAccessibility','/usr/bin/osascript',1,1,1,NULL,NULL);" \
  ;

}
