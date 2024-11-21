# frozen_string_literal: true

require 'json'

task :zed => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring Zed …' }

  zed_config = Pathname('~/.config/zed/settings.json').expand_path
  zed_config.dirname.mkpath

  zed_config.write JSON.pretty_generate(
    'theme' => 'Solarized Dark',
    'telemetry' => {
      'metrics' => false,
    },
    'buffer_font_size' => 13,
    'buffer_font_family' => 'SauceCodePro Nerd Font Mono',
    'seed_search_query_from_cursor' => 'never',
  )
end
