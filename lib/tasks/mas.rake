# frozen_string_literal: true

require 'macos_version'

task :mas => [:'brew:casks_and_formulae'] do
  # https://github.com/mas-cli/mas/issues/417
  if macos_version < Gem::Version.new('12')
    begin
      capture 'mas', 'account'
    rescue NonZeroExit
      raise 'Not signed in into App Store.' unless ci?
    end
  end

  wanted_apps = {
    # Apps
    '824171161' => 'Affinity Designer',
    '824183456' => 'Affinity Photo',
    '608292802' => 'Auction Sniper for eBay',
    '425264550' => 'Blackmagic Disk Speed Test',
    '420212497' => 'Byword',
    '924726344' => 'Deliveries',
    # '480664966' => 'Fusio',
    '463541543' => 'Gemini',
    '402989379' => 'iStudiez Pro',
    '409183694' => 'Keynote',
    '482898991' => 'LiveReload',
    '409203825' => 'Numbers',
    '409201541' => 'Pages',
    '419891002' => 'RapidClick',
    '443370764' => 'Repeater',
    '497799835' => 'Xcode',

    # Safari Extensions
    '1472432422' => 'Wayback Machine',
    '1495193038' => 'SimplyJSON',
    '1463298887' => 'UserScripts',
    '1591303229' => 'Vinegar - Tube Cleaner',
  }.freeze

  if macos_version < Gem::Version.new('15')
    wanted_apps['417375580'] = 'BetterSnapTool'
  end

  installed_apps = Pathname.glob('/Applications/*.app').map { |app| app.basename('.app').to_s }

  apps = wanted_apps.reject { |_, name| installed_apps.include?(name) }

  begin
    install_pool = Concurrent::FixedThreadPool.new(10)
    serial_executor = Concurrent::SingleThreadExecutor.new

    apps.map { |id, name|
      puts ANSI.blue { "Installing “#{name}” …" }
      Concurrent::Promise.execute(executor: install_pool) {
        # On CI, only check if the app ID is correct.
        if ci?
          # Still available, but only if previously purchased.
          next if %w[
            824171161
            824183456
            463541543
            924726344
            608292802
            1514164630
            482898991
          ].include?(id)

          capture 'mas', 'info', id
          next
        end

        capture 'mas', 'install', id
      }.then(executor: serial_executor) {
        puts ANSI.green { "Installed “#{name}”." }
      }
    }.each(&:wait!)
  ensure
    install_pool.shutdown
    serial_executor.shutdown
  end
end
