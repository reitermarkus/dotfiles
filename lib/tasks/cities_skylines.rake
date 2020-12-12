# frozen_string_literal: true

task :cities_skylines do
  mods = Pathname('~/Library/Application Support/Colossal Order/Cities_Skylines/Addons/Mods').expand_path

  Dir.mktmpdir do |tmpdir|
    repo = 'cities-skylines_force-res'

    command '/usr/bin/curl', '--silent', '--location', "https://github.com/crashdump/#{repo}/tarball/HEAD",
            '-o', "#{tmpdir}/#{repo}.tar.gz"

    dir = mods.join(repo)
    dir.mkpath
    command '/usr/bin/tar', '-xf', "#{tmpdir}/#{repo}.tar.gz", '--strip-components', '1', '-C', dir.to_path
  end

  config = Pathname('~/Library/Application Support/Colossal Order/Cities_Skylines/gameSettings.cgs').expand_path

  if config.exist?
    config.write config.read
                   .sub("autoSave\x00", "autoSave\x01")
                   .sub("editorAutoSave\x00", "editorAutoSave\x01")
  end
end
