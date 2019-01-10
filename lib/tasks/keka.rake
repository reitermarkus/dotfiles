# frozen_string_literal: true

require 'tmpdir'

task :keka => [:'brew:casks_and_formulae'] do
  keka = capture('/usr/bin/mdfind', '-onlyin', '/', 'kMDItemCFBundleIdentifier == com.aone.keka').lines.first&.strip

  keka_resources = Pathname(keka).join('Contents/Resources')

  repo = 'osx-archive-icons'

  Dir.mktmpdir do |dir|
    command '/usr/bin/curl', '--silent', '--location', "https://github.com/reitermarkus/#{repo}/archive/master.zip", '-o', "#{dir}/master.zip"
    command '/usr/bin/ditto', '-xk', "#{dir}/master.zip", dir

    command "#{dir}/#{repo}-master/_convert_iconsets"

    FileUtils.cp Dir.glob("#{dir}/#{repo}-master/*.icns"), keka_resources
    FileUtils.rm_f keka_resources.join('extract.png')

    dmg_icns = '/System/Library/CoreServices/DiskImageMounter.app/Contents/Resources/diskcopy-doc.icns'
    FileUtils.cp dmg_icns, keka_resources.join('dmg.icns')
    FileUtils.cp dmg_icns, keka_resources.join('iso.icns')

    icons = {
      '7z' => '7z',
      'bzip' => 'bz',
      'bzip2' => 'bz2',
      'gzip' => 'gz',
      'rar' => 'rar',
      'tar' => 'tar',
      'tbz2' => 'tbz2',
      'tgz' => 'tgz',
      'zip' => 'zip',
      'xz' => 'xz',
    }

    icons.each do |name, extension|
      iconset = "#{dir}/#{repo}-master/#{extension}.iconset"

      FileUtils.cp "#{iconset}/icon_32x32.png", keka_resources.join("tab_#{name}.png")
      FileUtils.cp "#{iconset}/icon_32x32@2x.png", keka_resources.join("tab_#{name}@2x.png")
    end
  end
end
