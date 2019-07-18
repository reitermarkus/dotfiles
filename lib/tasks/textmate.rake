# frozen_string_literal: true

require 'defaults'
require 'tmpdir'

def extract_tbz(src, to:)
  dst = to
  FileUtils.mkdir_p dst
  command '/usr/bin/tar', '-xz', '-m', '-C', dst, '-f', src
end

def download_tbz(url, to:)
  dst = to

  Dir.mktmpdir do |dir|
    command '/usr/bin/curl', '-sL', '--fail', url, '-o', "#{dir}/#{File.basename(dst)}"
    extract_tbz "#{dir}/#{File.basename(dst)}", to: dst
  end
end

task :textmate do
  # Ensure that Ruby 1.8 is downloaded.
  download_tbz('https://archive.textmate.org/ruby/ruby_1.8.7.tbz', to: File.expand_path('~/Library/Application Support/TextMate/Ruby'))

  application_support = File.expand_path('~/Library/Application Support/TextMate')

  extract_tbz '/Applications/TextMate.app/Contents/Resources/DefaultBundles.tbz', to: application_support

  updates_default = "#{application_support}/Managed/Cache/org.textmate.updates.default"
  plist = Plist.parse_xml(File.read(updates_default))
  bundles = plist['bundles'].map { |bundle| [bundle['name'], bundle] }.to_h

  [
    'Arduino',
    'Docker',
    'LaTeX',
    'TOML',
    'SSH Config',
    'YAML',
  ].each do |name|
    bundle = bundles[name]['versions'].last
    download_tbz(bundle['url'], to: File.expand_path("#{application_support}/Managed/Bundles/#{name}.tmbundle"))
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
  
  # Force bundles to be re-indexed.
  FileUtils.rm_f File.expand_path('~/Library/Caches/com.macromates.TextMate/BundlesIndex.binary')

  capture '/usr/bin/killall', 'cfprefsd'
end
