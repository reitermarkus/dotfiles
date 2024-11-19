# frozen_string_literal: true

task :asdf => [:'brew:casks_and_formulae'] do
  asdf_data_dir = Pathname('~/.config/asdf')
  ENV['ASDF_DATA_DIR'] = asdf_data_dir.expand_path.to_s
  asdf_data_dir.expand_path.mkpath
  add_line_to_file fish_environment, "set -x ASDF_DATA_DIR #{asdf_data_dir}"
  add_line_to_file bash_environment, "export ASDF_DATA_DIR=#{asdf_data_dir}"

  asdf_config_file = asdf_data_dir.join('config')
  ENV['ASDF_CONFIG_FILE'] = asdf_config_file.expand_path.to_s
  add_line_to_file fish_environment, "set -x ASDF_CONFIG_FILE #{asdf_config_file}"
  add_line_to_file bash_environment, "export ASDF_CONFIG_FILE=#{asdf_config_file}"

  add_line_to_file asdf_config_file.expand_path, 'legacy_version_file = yes'

  command 'asdf', 'plugin', 'add', 'python'
  command 'asdf', 'global', 'python', 'system'
  command 'asdf', 'plugin', 'add', 'ruby'
  command 'asdf', 'global', 'ruby', 'system'

  defaults 'com.macromates.TextMate' do
    write 'environmentVariables', [
      {
        'enabled' => true,
        'name' => 'ASDF_DATA_DIR',
        'value' => '$HOME/.config/asdf',
      },
      {
        'enabled' => true,
        'name' => 'ASDF_CONFIG_FILE',
        'value' => '$HOME/.config/asdf/config',
      },
      {
        'enabled' => true,
        'name' => 'PATH',
        'value' => '$ASDF_DATA_DIR/shims:$PATH',
      },
    ], add: true
  end
end
