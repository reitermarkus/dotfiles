defaults_steam() {

  echo -b 'Setting defaults for Steam …'

  if "$(/usr/bin/osascript -e 'tell application "System Events" to get the name of every login item contains "Steam"')"; then
    /usr/bin/osascript -e 'tell application "System Events" to delete login item "Steam"'
  fi

  csgo_config_dir="${HOME}/Library/Application Support/Steam/userdata/46026291/730/local/cfg"

  /bin/mkdir -p "${csgo_config_dir}"

  {
    echo 'cl_autowepswitch 0'
    echo 'cl_radar_always_centered 0'
    echo 'cl_radar_scale 0.6'
    echo 'cl_hud_radar_scale 1.25'
    echo 'cl_radar_icon_scale_min 1'
    echo 'bind MWHEELUP +jump'
    echo 'bind MWHEELDOWN invnext'
    echo 'alias +jumpthrow "+jump;-attack;-attack2"'
    echo 'alias -jumpthrow "-jump"'
    echo 'bind j +jumpthrow'
    echo 'bind MOUSE4 +jumpthrow'
    echo 'developer 1'
    echo 'con_enable "1"'
    echo 'con_filter_text "Damage Given"'
    echo 'con_filter_text_out "Player:"'
    echo 'con_filter_enable 2'
  } > "${csgo_config_dir}/autoexec.cfg"

  {
    echo 'sv_cheats 1'
    echo 'mp_maxmoney 50000'
    echo 'mp_startmoney 50000'
    echo 'mp_freezetime 1'
    echo 'mp_roundtime_defuse 40'
    echo 'mp_roundtime_hostage 40'
    echo 'mp_buy_anywhere 1'
    echo 'mp_buytime 1000'
    echo 'sv_infinite_ammo 2'
    echo 'mp_warmup_end'
    echo 'god'
    echo 'sv_grenade_trajectory 1'
    echo 'bind n noclip'
  } > "${csgo_config_dir}/training.cfg"

}
