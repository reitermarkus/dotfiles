# frozen_string_literal: true

require 'iniparse'
require 'json'

MOONRAKER_INSTANCES = {
  'Longer LK5 Pro': {
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
  config_path = config_dir / 'cura.cfg'

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

  config_path.write config.to_ini

  printer_config_path = config_dir/'definition_changes/Longer+LK5+Pro_settings.inst.cfg'
  printer_config_path.dirname.mkpath
  printer_config_path.write <<~INI
    [general]
    version = 4
    name = Longer LK5 Pro_settings
    definition = longer_lk5pro

    [metadata]
    type = definition_changes
    setting_version = 21

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

  extra_nozzle_sizes = ["0.6"]
  extra_nozzle_sizes.each do |nozzle_size|
    nozzle_variant = (config_dir/"variants/longer/longer_lk5pro_#{nozzle_size}.inst.cfg")
    nozzle_variant.dirname.mkpath
    nozzle_variant.write <<~INI
      [general]
      name = 0.6mm Nozzle
      version = 4
      definition = longer_lk5pro

      [metadata]
      setting_version = 16
      type = variant
      hardware_type = nozzle

      [values]
      machine_nozzle_size = 0.6
    INI
  end
end
