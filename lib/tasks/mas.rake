namespace :mas do
  desc 'Install Apps from the App Store'
  task :apps do
    begin
      capture 'mas', 'account'
    rescue NonZeroExit
      next if ci?
      raise 'Not signed in into App Store.'
    end

    APPS = {
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
    }

    installed_apps = capture('mas', 'list').lines.map { |line| line.split(/\s+/).first }

    apps = APPS.reject { |id, _| installed_apps.include?(id) }

    begin
      install_pool = Concurrent::FixedThreadPool.new(10)
      serial_executor = Concurrent::SingleThreadExecutor.new

      apps.map { |id, name|
        puts "Installing '#{name}' …"
        Concurrent::Promise.execute(executor: install_pool) {
          capture 'mas', 'install', id
        }.then(executor: serial_executor) { |out, _|
          print out
          puts "Installed '#{name}'."
        }
      }.each(&:wait!)
    ensure
      install_pool.shutdown
      serial_executor.shutdown
    end
  end
end
