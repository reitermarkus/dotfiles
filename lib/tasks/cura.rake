# frozen_string_literal: true

require 'iniparse'
require 'json'

MOONRAKER_INSTANCES = {
  'Longer LK5 Pro' => {
    api_key: '',
    camera_url: '',
    frontend_url: '',
    output_format: 'ufp',
    power_device: '',
    retry_interval: '',
    trans_input: '',
    trans_output: '',
    trans_remove: '',
    upload_autohide_messagebox: false,
    upload_dialog: true,
    upload_remember_state: false,
    upload_start_print_job: false,
    url: 'http://lk5-pro.reiter.ooo/',
  },
}.freeze

task :cura => [:'brew:casks_and_formulae'] do
  cura_version = JSON.parse(
    capture('brew', 'info', '--json=v2', '--cask', 'ultimaker-cura'),
  ).fetch('casks').fetch(0).fetch('installed')
  cura_version = cura_version.match(/\A(\d+\.\d+)\.\d+\Z/)[1]

  config_dir = Pathname("~/Library/Application Support/cura/#{cura_version}").expand_path
  config_dir.mkpath
  config_path = config_dir/'cura.cfg'

  ini_content = if config_path.exist?
    config_path.read
  else
    ''
  end
  config = IniParse.parse(ini_content)

  general_config = config.section('general')
  general_config['accepted_user_agreement'] = true
  general_config['auto_slice'] = false
  general_config['theme'] = 'cura-dark'

  moonraker_config = config.section('moonraker')
  moonraker_instances = moonraker_config['instances']&.then { |json| JSON.parse(json) } || {}
  moonraker_instances.merge!(MOONRAKER_INSTANCES)
  moonraker_config['instances'] = moonraker_instances.to_json

  cura_config = config.section('cura')
  cura_config['active_machine'] = 'Longer LK5 Pro'

  config_path.write config.to_ini

  printer_config_path = config_dir/'machine_instances/Longer+LK5+Pro.global.cfg'
  printer_config_path.dirname.mkpath
  printer_config_path.write <<~INI
    [general]
    version = 5
    name = Longer LK5 Pro
    id = Longer LK5 Pro

    [metadata]
    setting_version = 22
    type = machine
    group_id = 1d892dcb-533f-42a7-99ed-d710aa8f7e5d
    group_name = Longer LK5 Pro

    [containers]
    0 = Longer LK5 Pro_user
    1 = empty_quality_changes
    2 = empty_intent
    3 = longer_global_standard
    4 = empty_material
    5 = empty_variant
    6 = Longer LK5 Pro_settings
    7 = longer_lk5pro
  INI

  printer_changes_path = config_dir/'definition_changes/Longer+LK5+Pro_settings.inst.cfg'
  printer_changes_path.dirname.mkpath
  printer_changes_path.write <<~INI
    [general]
    version = 4
    name = Longer LK5 Pro_settings
    definition = longer_lk5pro

    [metadata]
    type = definition_changes
    setting_version = 22

    [values]
    extruders_enabled_count = 1
    machine_head_with_fans_polygon = [[-22, 39], [-22, -34], [58, 39], [58, -34]]
    machine_start_gcode = ; LONGER Start G-code
    \t
    \tM140 S{material_bed_temperature_layer_0} ; set bed temperature
    \tM104 S{material_standby_temperature} ; set extruder temperature
    \t
    \tG21 ; metric values
    \tG90 ; absolute positioning
    \tM82 ; set extruder to absolute mode
    \tM107 ; start with the fan off
    \tG92 E0 ; Reset Extruder
    \t
    \tM190 S{material_bed_temperature_layer_0} ; set bed temperature and wait
    \tM104 S{material_print_temperature_layer_0} ; set extruder temperature
    \t
    \tG28 ; home all axes
    \tG1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
    \tG1 X0.1 Y10 Z0.3 F5000.0 ; Move to start position
    \t
    \tM109 S{material_print_temperature_layer_0} ; set extruder temperature and wait
    \t
    \tSKEW_PROFILE LOAD=default
    \t
    \tG1 X0.1 Y200.0 Z0.3 F1500.0 E15 ; Draw the first line
    \tG1 X0.4 Y200.0 Z0.3 F5000.0 ; Move to side a little
    \tG1 X0.4 Y20 Z0.3 F1500.0 E30 ; Draw the second line
    \tG92 E0 ; Reset Extruder
    \tG1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
    \tG1 X5 Y20 Z0.3 F5000.0 ; Move over to prevent blob squish
  INI

  printer_user_path = config_dir/'user/Longer+LK5+Pro_user.inst.cfg'

  unless printer_user_path.exist?
    printer_user_path.dirname.mkpath
    printer_user_path.write <<~INI
      [general]
      version = 4
      name = Longer LK5 Pro_user
      definition = longer_lk5pro

      [metadata]
      type = user
      setting_version = 22
      machine = Longer LK5 Pro

      [values]
    INI
  end

  extruder_config_path = config_dir/'extruders/longer_base_extruder_0+%232.extruder.cfg'
  extruder_config_path.dirname.mkpath
  extruder_config_path.write <<~INI
    [general]
    version = 5
    name = Extruder 1
    id = longer_base_extruder_0 #2

    [metadata]
    setting_version = 22
    type = extruder_train
    position = 0
    machine = Longer LK5 Pro
    enabled = True

    [containers]
    0 = longer_base_extruder_0 #2_user
    1 = empty_quality_changes
    2 = empty_intent
    3 = longer_0.4_PLA_standard
    4 = generic_pla_175
    5 = longer_lk5pro_0.4
    6 = longer_base_extruder_0 #2_settings
    7 = longer_base_extruder_0
  INI

  extruder_changes_path = config_dir/'definition_changes/longer_base_extruder_0+%232_settings.inst.cfg'
  extruder_changes_path.dirname.mkpath
  extruder_changes_path.write <<~INI
    [general]
    version = 4
    name = longer_base_extruder_0 #2_settings
    definition = longer_base_extruder_0

    [metadata]
    type = definition_changes
    setting_version = 22

    [values]
  INI

  extruder_user_path = config_dir/'user/longer_base_extruder_0+%232_user.inst.cfg'
  unless extruder_user_path.exist?
    extruder_user_path.dirname.mkpath
    extruder_user_path.write <<~INI
      [general]
      version = 4
      name = longer_base_extruder_0 #2_user
      definition = longer_lk5pro

      [metadata]
      type = user
      setting_version = 22
      extruder = longer_base_extruder_0 #2

      [values]
    INI
  end

  extra_nozzle_sizes = ['0.6']
  extra_nozzle_sizes.each do |nozzle_size|
    nozzle_variant = (config_dir/"variants/longer/longer_lk5pro_#{nozzle_size}.inst.cfg")
    nozzle_variant.dirname.mkpath
    nozzle_variant.write <<~INI
      [general]
      name = #{nozzle_size}mm Nozzle
      version = 4
      definition = longer_lk5pro

      [metadata]
      setting_version = 16
      type = variant
      hardware_type = nozzle

      [values]
      machine_nozzle_size = #{nozzle_size}
    INI
  end

  plugins = {
    'ArcWelderPlugin' => 'https://github.com/fieldOfView/Cura-ArcWelderPlugin/archive/refs/tags/v3.6.0.tar.gz',
    'AutoTowersGenerator' => 'https://github.com/kartchnb/AutoTowersGenerator/archive/refs/tags/v2.7.1.tar.gz',
    'CalibrationShapes' => 'https://github.com/5axes/Calibration-Shapes/archive/refs/tags/V2.2.4.tar.gz',
    'CustomSupportCylinder' => 'https://github.com/5axes/CustomSupportCylinder/archive/refs/tags/V2.8.0.tar.gz',
    'MoonrakerConnection' => 'https://github.com/emtrax-ltd/Cura2MoonrakerPlugin/archive/refs/tags/v1.7.1.tar.gz',
    'OrientationPlugin' => 'https://github.com/nallath/CuraOrientationPlugin/archive/refs/tags/v3.7.0.tar.gz',
    'PauseBackendPlugin' => 'https://github.com/fieldOfView/Cura-PauseBackendPlugin/archive/refs/tags/v3.6.0.tar.gz',
  }

  plugins.each do |name, url|
    Dir.mktmpdir do |tmpdir|
      command '/usr/bin/curl', '--silent', '--location', url,
              '-o', "#{tmpdir}/#{name}.tar.gz"

      plugin_dir = config_dir/'plugins'/name
      plugin_dir.mkpath
      command '/usr/bin/tar', '-xf', "#{tmpdir}/#{name}.tar.gz", '--strip-components', '1', '-C', plugin_dir.to_path
    end
  end
end
