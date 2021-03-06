# frozen_string_literal: true

require 'tmpdir'

task :keka => [:'brew:casks_and_formulae'] do
  keka_resources = Pathname('/Applications/Keka.app/Contents/Resources')

  repo = 'osx-archive-icons'

  Dir.mktmpdir do |dir|
    command '/usr/bin/curl', '--silent', '--location', "https://github.com/reitermarkus/#{repo}/tarball/HEAD",
            '-o', "#{dir}/#{repo}.tar.gz"
    command '/usr/bin/tar', '-xf', "#{dir}/#{repo}.tar.gz", '--strip-components', '1', '-C', dir

    FileUtils.rm "#{dir}/#{repo}.tar.gz"
    command "#{dir}/_convert_iconsets"

    FileUtils.cp Dir.glob("#{dir}/*.icns"), keka_resources
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
      iconset = "#{dir}/#{extension}.iconset"

      FileUtils.cp "#{iconset}/icon_32x32.png", keka_resources.join("tab_#{name}.png")
      FileUtils.cp "#{iconset}/icon_32x32@2x.png", keka_resources.join("tab_#{name}@2x.png")
    end
  end
end
