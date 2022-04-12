# frozen_string_literal: true

require 'json'

task :vscode do
  settings_path = Pathname('~/Library/Application Support/Code/User/settings.json').expand_path

  settings = {
    'trailing-spaces.trimOnSave' => true,
    'trailing-spaces.highlightCurrentLine' => false,
    # FIXME: https://github.com/shardulm94/vscode-trailingspaces/issues/55
    # FIXME: https://github.com/shardulm94/vscode-trailingspaces/issues/56
    'trailing-spaces.syntaxIgnore' => ['markdown'],
    'workbench.preferredLightColorTheme' => 'Solarized Light',
    'workbench.preferredDarkColorTheme' => 'Solarized Dark',
    'window.autoDetectColorScheme' => true,
    'editor.fontFamily' => 'SauceCodePro Nerd Font Mono',
    'editor.cursorWidth' => 1,
    'editor.tabSize' => 2,
    'editor.fontSize' => 13,
  }

  # Combine wanted with existing settings.
  settings = JSON.parse(settings_path.read).merge(settings) if settings_path.exist?

  settings_path.write JSON.pretty_generate(settings)

  extensions = [
    'EditorConfig.EditorConfig',
    'shardulm94.trailing-spaces',
  ]

  extensions.each do |extension|
    command 'code', '--install-extension', extension
  end
end
