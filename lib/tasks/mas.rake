# frozen_string_literal: true

task :mas => [:'brew:casks_and_formulae'] do
  begin
    capture 'mas', 'account'
  rescue NonZeroExit
    raise 'Not signed in into App Store.' unless ci?
  end

  APPS = {
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
    '954196690' => 'RegexToolbox',
    '443370764' => 'Repeater',
    '497799835' => 'Xcode',
    '892115848' => 'yRegex',
  }.freeze

  installed_apps = capture('mas', 'list').lines.map { |line| line.split(/\s+/).first }

  apps = APPS.reject { |id, _| installed_apps.include?(id) }

  begin
    install_pool = Concurrent::FixedThreadPool.new(10)
    serial_executor = Concurrent::SingleThreadExecutor.new

    apps.map { |id, name|
      # Check if the app ID is correct.
      if ci?
        next if id == '463541543' # Still available, but only if previously purchased.

        capture 'mas', 'info', id
        next
      end

      puts ANSI.blue { "Installing “#{name}” …" }
      Concurrent::Promise.execute(executor: install_pool) {
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
