# frozen_string_literal: true

task :kicad => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring KiCad …' }

  kicad_version = JSON.parse(capture('brew', 'info', '--json=v2', '--cask', 'kicad')).fetch('casks')[0].fetch('installed')
  kicad_major_minor_version = kicad_version[/(\d+\.\d+)/, 1]

  raise unless kicad_major_minor_version

  kicad_common = Pathname("~/Library/Preferences/kicad/#{kicad_major_minor_version}/kicad_common.json").expand_path

  json = kicad_common.exist? ? JSON.parse(kicad_common.read) : {}

  json['input'] ||= {}
  json['input']['auto_pan'] = true
  json['input']['center_on_zoom'] = false

  json['environment'] ||= {}
  json['environment']['vars'] ||= {}
  json['environment']['vars']['EASYEDA2KICAD'] = File.expand_path('~/Documents/KiCad/easyeda2kicad')

  kicad_common.write JSON.pretty_generate(json)
end
