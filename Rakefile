# frozen_string_literal: true

$LOAD_PATH.unshift 'lib'

require 'require'
require 'ci'

Rake.add_rakelib 'lib/tasks'

require 'concurrent-edge'
require 'ansi'

module Rake
  class Task
    module PATH
      def invoke_with_call_chain(_, invocation_chain)
        current_path = ENV['PATH']&.split(File::PATH_SEPARATOR)
        default_path = Dir.glob('/etc/paths{,.d/*}')
                         .flat_map { |f| File.read(f).strip.split("\n") }

        if File.exist?('/etc/environment') && (path = File.read('/etc/environment')[/PATH=(?:"([^"]+)"|'([^']+)')/, 1])
          default_path += path.split(File::PATH_SEPARATOR)
        end

        if default_path.empty?
          default_path = ['/usr/local/bin', '/usr/local/sbin', '/usr/bin', '/usr/sbin', '/bin', '/sbin']
        end

        ENV['PATH'] = [*current_path, *default_path].uniq.join(File::PATH_SEPARATOR)

        super
      end
    end

    prepend PATH
  end
end

DOTFILES_DIR = __dir__

ALLOWED_VARIABLES = [
  'Apple_PubSub_Socket_Render',
  'CI',
  'HOME',
  'LANG',
  'LOGNAME',
  *(ENV['CODESPACES'] ? 'PATH' : nil),
  'PWD',
  'SHELL',
  'SHLVL',
  'SSH_AUTH_SOCK',
  'SUDO_ASKPASS',
  'TERM',
  'TERM_PROGRAM',
  'TERM_PROGRAM_VERSION',
  'TERM_SESSION_ID',
  'TMPDIR',
  'USER',
  'XPC_FLAGS',
  'XPC_SERVICE_NAME',
].freeze

ENV.delete_if { |k, _|
  !ALLOWED_VARIABLES.include?(k)
}

task :linux => [
  :files,
  :fonts,
  :git,
  :gpg,
  :vscode,
  :zed,
]

task :windows => [
  :cs2,
]

task :macos => [
  :ansible,
  :files,
  :'xcode:command_line_utilities',
  :brew,
  :node,
  :ruby,
  :rust,
  :python,
  :mas,
  :'xcode:accept_license',
  :fonts,
  :repos,
  :mackup,
  :local_scripts,
  :bash,
  :fish,
  :fork,
  :krew,
  :direnv,
  :git,
  :github,
  :gpg,
  :cura,
  :'xcode:defaults',
  :music,
  :rapidclick,
  :hazel,
  :virtualbox,
  :element,
  :steam,
  :mumble,
  :teamspeak,
  :cs2,
  :cities_skylines,
  :tex,
  :skim,
  :ccache,
  :sccache,
  :make,
  :pam,
  :keyboard,
  :ui,
  :monitorcontrol,
  :origin,
  :rocket,
  :safari,
  :locale,
  :startup,
  :transmission,
  :locate_db,
  :menubar,
  :mediathekview,
  :deliveries,
  :tower,
  :bettersnaptool,
  :screensaver,
  :parallels,
  :vagrant,
  :telegram,
  :finder,
  :crash_reporter,
  :dnsmasq,
  :loginwindow,
  :textmate,
  :vscode,
  :dock,
  :softwareupdate,
  :terminal,
  :rfc,
  :x11,
  :z,
  :keka,
  :arduino,
  :mouse_trackpad,
  :userscripts,
  :thangs,
  :zed,
]
