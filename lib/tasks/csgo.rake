# frozen_string_literal: true

task :csgo do
  puts ANSI.blue { 'Setting up CS:GO configuration …' }

  csgo_config_dir = File.expand_path('~/Library/Application Support/Steam/userdata/46026291/730/local/cfg')

  FileUtils.mkdir_p csgo_config_dir

  File.write "#{csgo_config_dir}/autoexec.cfg", <<~CFG
    gameinstructor_enable 0
    ui_mainmenu_bkgnd_movie1 "blacksite"
    cl_autowepswitch 0
    alias +jumpthrow "+jump;-attack;-attack2"
    alias -jumpthrow "-jump"
    bind j +jumpthrow
    alias +forwardjumpthrow "+forward;+jumpthrow"
    alias -forwardjumpthrow "-forward;-jumpthrow"
    bind h +forwardjumpthrow
    alias +djump "+jump;+duck"
    alias -djump "-jump;-duck"
    bind ALT +djump

    // Matchmaking
    cl_color 2
    mm_dedicated_search_maxping 40

    // Graphics
    fps_max 0
    mat_queue_mode 2
    cl_forcepreload 1

    // Network
    rate 786432

    // HUD & Radar
    cl_radar_always_centered 0
    cl_radar_scale 0.6
    hud_scaling 0.75
    cl_hud_radar_scale 1.25
    cl_radar_icon_scale_min 1
    safezonex 0.85
    safezoney 0.85

    // Show Teammates
    cl_teamid_overhead_always 1
    bind tab "+score;+cl_show_team_equipment"

    // Don't Mute Enemies
    cl_mute_enemy_team 0

    // “Damage Given” Messages
    developer 1
    con_enable "1"
    con_filter_text "Damage Given"
    con_filter_text_out "Player:"
    con_filter_enable 2

    // Crosshair
    cl_crosshair_drawoutline 1
    cl_crosshair_outlinethickness 1
    cl_crosshair_sniper_show_normal_inaccuracy 0
    cl_crosshair_sniper_width 2
    cl_crosshair_t 0
    cl_crosshairalpha 200
    cl_crosshaircolor 5
    cl_crosshaircolor_b 100
    cl_crosshaircolor_g 0
    cl_crosshaircolor_r 255
    cl_crosshairdot 0
    cl_crosshairgap -1.5
    cl_crosshairgap_useweaponvalue 0
    cl_crosshairscale 0
    cl_crosshairsize 2.5
    cl_crosshairstyle 5
    cl_crosshairthickness 0
    cl_crosshairusealpha 1
    cl_show_observer_crosshair 2

    // Mouse
    sensitivity 0.7
    unbind MWHEELUP
    unbind MWHEELDOWN
    bind MOUSE4 +jumpthrow

    // Sound
    snd_mapobjective_volume 0.0
    snd_menumusic_volume 0.0
    snd_mvp_volume 0.3
    snd_roundstart_volume 0.05
    snd_roundend_volume 0.05
    voice_scale 0.5
    volume 0.3
    snd_tensecondwarning_volume 0.15
    snd_mute_losefocus 0

    host_writeconfig
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

  output, = capture 'system_profiler', 'SPDisplaysDataType'

  vendor_id = output.scan(/Vendor: [^\s]+ \(0x(\h+)\)/).first&.first&.to_i(16)
  device_id = output.scan(/Device ID: 0x(\h+)/).first&.first&.to_i(16)
  width, height = output.scan(/Resolution: (\d+) x (\d+)/).first

  next if [vendor_id, device_id, width, height].any?(&:nil?)

  File.write "#{csgo_config_dir}/video.txt", <<~CFG
    "VideoConfig" {
      "setauto.cpu_level"                "2"
      "setauto.gpu_level"                "3"
      "setauto.mat_antialias"            "0"
      "setauto.mat_aaquality"            "0"
      "setauto.mat_forceaniso"           "1"
      "setting.mat_vsync"                "0"
      "setting.mat_triplebuffered"       "0"
      "setting.mat_grain_scale_override" "-1.0"
      "setauto.gpu_mem_level"            "2"
      "setting.mem_level"                "3"
      "setting.mat_queue_mode"           "-1"
      "setauto.csm_quality_level"        "3"
      "setting.mat_software_aa_strength" "1"
      "setting.mat_motion_blur_enabled"  "0"
      "setting.defaultres"               "#{width}"
      "setting.defaultresheight"         "#{height}"
      "setting.aspectratiomode"          "2"
      "setting.fullscreen"               "1"
      "setting.nowindowborder"           "1"
    }
  CFG

  File.write "#{csgo_config_dir}/videodefaults.txt", <<~CFG
    "config" {
      "setting.csm_quality_level"             "3"
      "setting.mat_software_aa_strength"      "1"
      "VendorID"                              "#{vendor_id}"
      "DeviceID"                              "#{device_id}"
      "setting.fullscreen"                    "1"
      "setting.nowindowborder"                "0"
      "setting.aspectratiomode"               "-1"
      "setting.mat_vsync"                     "0"
      "setting.mat_triplebuffered"            "0"
      "setting.mat_monitorgamma"              "2.200000"
      "setting.mat_queue_mode"                "-1"
      "setting.mat_motion_blur_enabled"       "0"
      "setting.gpu_mem_level"                 "2"
      "setting.gpu_level"                     "3"
      "setting.mat_antialias"                 "0"
      "setting.mat_aaquality"                 "0"
      "setting.mat_forceaniso"                "1"
      "setting.cpu_level"                     "2"
      "setting.videoconfig_version"           "1"
      "setting.defaultres"                    "#{width}"
      "setting.defaultresheight"              "#{height}"
    }
  CFG
end
