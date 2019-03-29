# frozen_string_literal: true

task :cities_skylines do
  mods = Pathname('~/Library/Application Support/Colossal Order/Cities_Skylines/Addons/Mods').expand_path

  Dir.mktmpdir do |tmpdir|
    command '/usr/bin/curl', '--silent', '--location', 'https://github.com/crashdump/cities-skylines_force-res/archive/master.tar.gz', '-o', "#{tmpdir}/master.tar.gz"

    dir = mods.join('cities-skylines_force-res')
    dir.mkpath
    command '/usr/bin/tar', '-x', '--strip-components', '1', '-C', dir.to_s, '-f', "#{tmpdir}/master.tar.gz"
  end

  config = Pathname('~/Library/Application Support/Colossal Order/Cities_Skylines/gameSettings.cgs').expand_path

  if config.exist?
    config.write config.read
                   .sub("autoSave\x00", "autoSave\x01")
                   .sub("editorAutoSave\x00", "editorAutoSave\x01")
  end
end
