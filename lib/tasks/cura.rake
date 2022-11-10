# frozen_string_literal: true

require 'iniparse'
require 'json'

MOONRAKER_INSTANCES = {
  "Longer LK5 Pro" => {
    api_key: "",
    camera_url: "",
    frontend_url: "",
    output_format: "ufp",
    power_device: "",
    retry_interval: "",
    trans_input: "",
    trans_output: "",
    trans_remove: "",
    upload_autohide_messagebox: false,
    upload_dialog: true,
    upload_remember_state: false,
    upload_start_print_job: false,
    url: "http://lk5-pro.reiter.ooo/",
  }
}

task :cura => [:'brew:casks_and_formulae'] do
  cura_version = JSON.parse(capture('brew', 'info', '--json=v2', '--cask',
                                    'ultimaker-cura')).fetch('casks').fetch(0).fetch('installed')
  cura_version = cura_version.match(/\A(\d+\.\d+)\.\d+\Z/)[1]

  config_dir = Pathname("~/Library/Application Support/cura/#{cura_version}").expand_path
  config_path = config_dir / 'cura.cfg'

  config = IniParse.parse(config_path.read)

  general_config = config.section('general')
  general_config['accepted_user_agreement'] = true
  general_config['auto_slice'] = false
  general_config['theme'] = 'cura-dark'

  moonraker_config = config.section('moonraker')
  moonraker_instances = moonraker_config['instances']&.yield_self { |json| JSON.parse(json) } || {}
  moonraker_instances.merge!(MOONRAKER_INSTANCES)
  moonraker_config['instances'] = moonraker_instances.to_json

  config_path.write config.to_ini
end
