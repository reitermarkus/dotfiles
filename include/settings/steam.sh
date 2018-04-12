defaults_steam() {

  echo -b 'Setting defaults for Steam …'

  if "$(/usr/bin/osascript -e 'tell application "System Events" to get the name of every login item contains "Steam"')"; then
    /usr/bin/osascript -e 'tell application "System Events" to delete login item "Steam"'
  fi

  {
    echo 'sv_cheats 1'
    echo 'mp_maxmoney 50000'
    echo 'mp_startmoney 50000'
    echo 'mp_freezetime 1'
    echo 'mp_roundtime_defuse 40'
    echo 'mp_roundtime_hostage 40'
    echo 'mp_buy_anywhere 1'
    echo 'mp_buytime 1000'
    echo 'sv_infinite_ammo 1'
    echo 'mp_warmup_end'
    echo 'god'
    echo 'sv_grenade_trajectory 1'
    echo 'bind n noclip'
  } > "${HOME}/Library/Application Support/Steam/userdata/46026291/730/local/cfg/training.cfg"

}
