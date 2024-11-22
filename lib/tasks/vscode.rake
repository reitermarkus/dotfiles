# frozen_string_literal: true

require 'json'

task :vscode => [:'brew:casks_and_formulae', :rust] do
  if linux?
    Dir.mktmpdir do |tmpdir|
      command '/usr/bin/curl', '--silent', '--location', 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64',
              '-o', "#{tmpdir}/vscode.deb"
      command sudo, 'apt', 'install', '--yes', './vscode.deb'
    end
  end

  config_dir = if macos?
    Pathname('~/Library/Application Support/Code/User').expand_path
  else
    Pathname('~/.config/Code/User').expand_path
  end
  keybindings_path = config_dir/'keybindings.json'
  settings_path = config_dir/'settings.json'
  config_dir.mkpath

  font_family = if macos?
    'SauceCodeProNFM'
  else
    'SauceCodePro NFM'
  end
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
    'terminal.integrated.allowChords' => false,
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
    'files.insertFinalNewline' => true,
    'security.workspace.trust.untrustedFiles' => 'open',
  }

  if linux?
    settings['window.enableMenuBarMnemonics'] = false
    settings['window.titleBarStyle'] = 'custom'
    settings['window.customMenuBarAltFocus'] = false
  end

  # Combine wanted with existing settings.
  settings = JSON.parse(settings_path.read).merge(settings) if settings_path.exist?

  settings_path.write JSON.pretty_generate(settings)

  keybindings = [
    {
      'key' => 'home',
      'command' => 'cursorLineStart',
    },
    {
      'key' => 'home',
      'command' => '-cursorHome',
    },
    {
      'key' => 'end',
      'command' => 'cursorLineEnd',
    },
    {
      'key' => 'end',
      'command' => '-cursorEnd',
    },
    {
      'key' => 'shift+home',
      'command' => 'cursorLineStartSelect',
    },
    {
      'key' => 'shift+end',
      'command' => 'cursorLineEndSelect',
    },
    {
      'key' => 'shift+end',
      'command' => '-cursorEndSelect',
      'when' => 'textInputFocus',
    },
    {
      'key' => 'ctrl+k',
      'command' => 'deleteAllRight',
    },
    {
      'key' => 'ctrl+[BracketRight]',
      'command' => 'editor.action.fontZoomIn',
      'when' => 'textInputFocus',
    },
    {
      'key' => 'ctrl+-',
      'command' => 'editor.action.fontZoomOut',
      'when' => 'textInputFocus',
    },
    {
      'key' => 'ctrl+0',
      'command' => 'editor.action.fontZoomReset',
      'when' => 'textInputFocus',
    },
    {
      'key' => 'ctrl+[BracketRight]',
      'command' => 'workbench.action.terminal.fontZoomIn',
      'when' => 'terminalFocus',
    },
    {
      'key' => 'ctrl+-',
      'command' => 'workbench.action.terminal.fontZoomOut',
      'when' => 'terminalFocus',
    },
    {
      'key' => 'ctrl+0',
      'command' => 'workbench.action.terminal.fontZoomReset',
      'when' => 'terminalFocus',
    },
  ]

  if linux?
    keybindings += [
      {
        'key' => 'shift+meta+k',
        'command' => 'workbench.action.terminal.clear',
        'when' => 'terminalFocus',
      },
      {
        'key' => 'ctrl+shift+c',
        'command' => '-workbench.action.terminal.openNativeConsole',
        'when' => '!terminalFocus',
      },
      {
        'key' => 'ctrl+shift+c',
        'command' => 'editor.action.clipboardCopyAction',
      },
    ]
  end

  keybindings_path.write JSON.pretty_generate(keybindings)

  extensions = [
    'EditorConfig.EditorConfig',
    'shardulm94.trailing-spaces',
    'rust-lang.rust-analyzer',
    'ZixuanWang.linkerscript',
    'tamasfe.even-better-toml',
    'vadimcn.vscode-lldb',
    'github.vscode-github-actions',
    'ms-vsliveshare.vsliveshare',
    'samverschueren.final-newline',
  ]

  extensions.each do |extension|
    command 'code', '--install-extension', extension, '--force'
  end
end
