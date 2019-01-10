# frozen_string_literal: true

task :crash_reporter do
  puts ANSI.blue { 'Configuring Crash Reporter …' }

  # Show crash reports in Notification Center instead of dialog.
  defaults 'com.apple.CrashReporter' do
    write 'UseUNC', 1
  end
end
