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

    dmg_icns_glob = '/System/Library/CoreServices/DiskImageMounter.app/Contents/Resources/{diskcopy-doc,diskimage}.icns'
    dmg_icns = Dir.glob(dmg_icns_glob).first
    FileUtils.cp dmg_icns, keka_resources.join('dmg.icns')
    FileUtils.cp dmg_icns, keka_resources.join('iso.icns')
  end
end
