# frozen_string_literal: true

task :mumble do
  defaults 'net.sourceforge.mumble.Mumble' do
    write 'consent.pingserversdialogviewed', true

    write 'audio.headphone', true
    write 'audio.quality', 192000
    write 'audio.noiseCancelMode', 3
    write 'audio.echooptionid', 3
    write 'audio.input', 'CoreAudio'
    write 'coreaudio.input', 'AppleUSBAudioEngine:Razer Inc:Razer Seiren X:UC1805L01201438:2'
    write 'audio.output', 'CoreAudio'
    write 'coreaudio.output', 'CC-98-8B-E2-FE-0B:output'

    write 'net.autoconnect', true
  end
end
