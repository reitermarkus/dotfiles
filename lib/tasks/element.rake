# frozen_string_literal: true

task :element do
  element_electron_config = Pathname('~/Library/Application Support/Element/electron-config.json').expand_path

  config = if element_electron_config.exist?
    JSON.parse(element_electron_config.read)
  else
    {}
  end

  config['warnBeforeExit'] = false

  element_electron_config.write JSON.pretty_generate(config)
end
