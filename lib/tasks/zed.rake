# frozen_string_literal: true

require 'json'

task :zed => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring Zed …' }

  zed_config_dir = Pathname('~/.config/zed').expand_path
  zed_config_dir.mkpath
  zed_settings = zed_config_dir.join('settings.json')
  zed_keymap = zed_config_dir.join('keymap.json')

  zed_settings.write JSON.pretty_generate(
    theme: {
      mode: 'system',
      light: 'Zed Legacy: Solarized Light',
      dark: 'Zed Legacy: Solarized Dark',
    },
    telemetry: {
      metrics: false,
    },
    buffer_font_size: 13,
    buffer_font_family: 'SauceCodePro Nerd Font Mono',
    seed_search_query_from_cursor: 'never',
    auto_install_extensions: {
      'zed-legacy-themes': true,
      html: true,
      dockerfile: true,
      'docker-compose': false,
      toml: true,
      xml: true,
      scss: true,
      nix: true,
      ruff: true,
      pylsp: true,
      fish: true,
      helm: true,
      ruby: true,
    },
    tab_size: 2,
    lsp: {
      # TOML
      taplo: {
        settings: {
          array_auto_expand: false,
          array_auto_collapse: false,
          column_width: 120,
        },
      },
    },
  )

  next unless linux?

  zed_keymap.write JSON.pretty_generate([
    {
      context: 'Workspace',
      bindings: {},
    },
    {
      context: 'Editor',
      bindings: {
        'ctrl-shift-c': 'editor::Copy',
        'ctrl-shift-v': 'editor::Paste',
        'ctrl-shift-x': 'editor::Cut',
        'ctrl-k': 'editor::DeleteToEndOfLine',
      },
    },
    {
      context: 'Terminal',
      bindings: {},
    },
  ])
end
