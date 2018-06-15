task :crash_reporter do
  # Show crash reports in Notification Center instead of dialog.
  defaults 'com.apple.CrashReporter' do
    write 'UseUNC', 1
  end
end
