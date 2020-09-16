# frozen_string_literal: true

task :mas => [:'brew:casks_and_formulae'] do
  begin
    capture 'mas', 'account'
  rescue NonZeroExit
    raise 'Not signed in into App Store.' unless ci?
  end

  wanted_apps = {
    '824171161' => 'Affinity Designer',
    '824183456' => 'Affinity Photo',
    '608292802' => 'Auction Sniper for eBay',
    '417375580' => 'BetterSnapTool',
    '420212497' => 'Byword',
    '924726344' => 'Deliveries',
    '480664966' => 'Fusio',
    '463541543' => 'Gemini',
    '402989379' => 'iStudiez Pro',
    '409183694' => 'Keynote',
    '482898991' => 'LiveReload',
    '409203825' => 'Numbers',
    '409201541' => 'Pages',
    '419891002' => 'RapidClick',
    '443370764' => 'Repeater',
    '497799835' => 'Xcode',
  }.freeze

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
          next if id == '463541543' # Still available, but only if previously purchased.

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
