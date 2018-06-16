require 'defaults'
require 'tmpdir'

task :textmate do
  # Ensure that Ruby 1.8 is downloaded.
  Dir.mktmpdir do |dir|
    command '/usr/bin/curl', '-sL', 'https://archive.textmate.org/ruby/ruby_1.8.7.tbz', '-o', "#{dir}/ruby_1.8.7.tbz"
    ruby_dir = File.expand_path('~/Library/Application Support/TextMate/Ruby')
    FileUtils.mkdir_p File.expand_path(ruby_dir)
    command '/usr/bin/tar', '-xz', '-m', '-C', ruby_dir, '-f', "#{dir}/ruby_1.8.7.tbz"
  end

  defaults 'com.macromates.TextMate' do
    write 'environmentVariables', [
      {
        'enabled' => true,
        'name' => 'PATH',
        'value' => '/usr/local/bin:$PATH',
      },
    ], add: true
  end

  capture '/usr/bin/killall', 'cfprefsd'
end
