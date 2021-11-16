# frozen_string_literal: true

require 'command'
require 'defaults'
require 'killall'
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
  ruby_path = File.expand_path('~/Library/Application Support/TextMate/Ruby')
  download_tbz('https://archive.textmate.org/ruby/ruby_1.8.7.tbz', to: ruby_path)

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

    delete 'themeAppearance'
    write 'universalThemeUUID', '38E819D9-AE02-452F-9231-ECC3B204AFD7' # Solarized Light
    write 'darkModeThemeUUID', 'A4299D9B-1DE5-4BC4-87F6-A757E71B1597' # Solarized Dark
  end

  # Force bundles to be re-indexed.
  FileUtils.rm_f File.expand_path('~/Library/Caches/com.macromates.TextMate/BundlesIndex.binary')

  killall 'cfprefsd'
end
