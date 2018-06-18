task :csgo do
  puts ANSI.blue { 'Setting up CS:GO configuration …' }

  csgo_config_dir = File.expand_path('~/Library/Application Support/Steam/userdata/46026291/730/local/cfg')

  FileUtils.mkdir_p csgo_config_dir

  File.write "#{csgo_config_dir}/autoexec.cfg", <<~CFG
    cl_autowepswitch 0
    cl_radar_always_centered 0
    cl_radar_scale 0.6
    cl_hud_radar_scale 1.25
    cl_radar_icon_scale_min 1
    bind MWHEELUP +jump
    bind MWHEELDOWN invnext
    alias +jumpthrow "+jump;-attack;-attack2"
    alias -jumpthrow "-jump"
    bind j +jumpthrow
    bind MOUSE4 +jumpthrow
    alias +forwardjumpthrow "+forward;+jumpthrow"
    alias -forwardjumpthrow "-forward;-jumpthrow"
    bind h +forwardjumpthrow

    # “Damage Given” Messages
    developer 1
    con_enable "1"
    con_filter_text "Damage Given"
    con_filter_text_out "Player:"
    con_filter_enable 2

    # Crosshair
    cl_crosshair_drawoutline 1
    cl_crosshair_outlinethickness 1
    cl_crosshair_sniper_show_normal_inaccuracy 0
    cl_crosshair_sniper_width 2
    cl_crosshair_t 0
    cl_crosshairalpha 255
    cl_crosshaircolor 5
    cl_crosshaircolor_b 100
    cl_crosshaircolor_g 0
    cl_crosshaircolor_r 255
    cl_crosshairdot 0
    cl_crosshairgap -3
    cl_crosshairgap_useweaponvalue 0
    cl_crosshairscale 0
    cl_crosshairsize 2.0
    cl_crosshairstyle 4
    cl_crosshairthickness 0
    cl_crosshairusealpha 1
  CFG

  File.write "#{csgo_config_dir}/training.cfg", <<~CFG
    sv_cheats 1
    mp_maxmoney 50000
    mp_startmoney 50000
    mp_freezetime 1
    mp_roundtime_defuse 60
    mp_roundtime_hostage 60
    mp_buy_anywhere 1
    mp_buytime 1000
    sv_infinite_ammo 2
    mp_warmup_end
    bot_kick all
    mp_solid_teammates 1
    god
    sv_grenade_trajectory 1
    bind n noclip
  CFG
end
