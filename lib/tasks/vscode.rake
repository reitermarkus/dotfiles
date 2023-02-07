# frozen_string_literal: true

require 'json'

task :vscode => [:'brew:casks_and_formulae', :rust] do
  settings_path = Pathname('~/Library/Application Support/Code/User/settings.json').expand_path
  settings_path.dirname.mkpath

  font_family = 'SauceCodePro Nerd Font Mono'
  font_size = 13

  settings = {
    'trailing-spaces.trimOnSave' => true,
    'trailing-spaces.highlightCurrentLine' => false,
    # FIXME: https://github.com/shardulm94/vscode-trailingspaces/issues/55
    # FIXME: https://github.com/shardulm94/vscode-trailingspaces/issues/56
    'trailing-spaces.syntaxIgnore' => ['markdown'],
    'workbench.preferredLightColorTheme' => 'Solarized Light',
    'workbench.preferredDarkColorTheme' => 'Solarized Dark',
    'window.autoDetectColorScheme' => true,
    # Don't change focus to VS Code when debugger breaks.
    'debug.focusWindowOnBreak' => false,
    'editor.cursorWidth' => 1,
    'editor.tabSize' => 2,
    'editor.fontFamily' => font_family,
    'editor.fontSize' => font_size,
    'editor.minimap.enabled' => false,
    'editor.find.seedSearchStringFromSelection' => 'never',
    'terminal.integrated.fontFamily' => font_family,
    'terminal.integrated.fontSize' => font_size,
    'rust-analyzer.server.extraEnv' => {
      'CARGO_HOME' => ENV.fetch('CARGO_HOME'),
      'RUSTUP_HOME' => ENV.fetch('RUSTUP_HOME'),
      'CARGO' => which('cargo'),
      'RUSTC' => which('rustc'),
    },
    'rust-analyzer.assist.importGranularity' => 'item',
    'files.associations' => {
      '*.x' => 'linkerscript',
    },
  }

  # Combine wanted with existing settings.
  settings = JSON.parse(settings_path.read).merge(settings) if settings_path.exist?

  settings_path.write JSON.pretty_generate(settings)

  extensions = [
    'EditorConfig.EditorConfig',
    'shardulm94.trailing-spaces',
    'rust-lang.rust-analyzer',
    'ZixuanWang.linkerscript',
    'bungcip.better-toml',
  ]

  extensions.each do |extension|
    command 'code', '--install-extension', extension, '--force'
  end
end
