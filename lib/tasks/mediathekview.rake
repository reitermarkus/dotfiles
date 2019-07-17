# frozen_string_literal: true

require 'user'

task :mediathekview do
  mediathekview_config_dir = Pathname('~/.mediathek3').expand_path
  mediathekview_config_dir.mkpath

  settings_xml = mediathekview_config_dir.join('settings.xml')
  mediathek_xml = mediathekview_config_dir.join('mediathek.xml')

  user_agent = 'Mozilla/5.0'

  settings_xml.write <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <settings>
      <application>
        <user_agent>#{user_agent}</user_agent>
      </application>
      <geo>
        <location>AT</location>
      </geo>
    </settings>
  XML

  output, = capture 'system_profiler', 'SPDisplaysDataType'
  width, height = output.scan(/Resolution: (\d+) x (\d+)/).first.map(&:to_i)

  mediathek_xml.write <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <Mediathek>
      <system>
      	<Groesse>2000:#{height - 23}:#{width / 2 - 1000}:23</Groesse>
        <Hinweis-Nr-angezeigt>8</Hinweis-Nr-angezeigt>
        <Version-Programmset>4</Version-Programmset>
      </system>
      <Programmset>
        <Name>Mac Speichern</Name>
        <Praefix>http</Praefix>
        <Suffix>mp4,mp3,m4v,flv,m4a</Suffix>
        <Zielpfad>#{HOME}/Downloads</Zielpfad>
        <Zieldateiname>%t-%T-%z</Zieldateiname>
        <Abspielen>false</Abspielen>
        <Speichern>true</Speichern>
        <Button>true</Button>
        <Abo>true</Abo>
        <max-Laenge>25</max-Laenge>
        <Beschreibung>Standardset zum Speichern der Filme</Beschreibung>
      </Programmset>
      <Programm>
        <Programmname>flvstreamer</Programmname>
        <Zieldateiname>%t-%T-%Z.flv</Zieldateiname>
        <Programmpfad>/Applications/MediathekView.app/Contents/Resources/flvstreamer_macosx_intel_32bit_latest</Programmpfad>
        <Programmschalter>%F --resume -o **</Programmschalter>
        <Praefix>rtmp</Praefix>
        <Restart>true</Restart>
      </Programm>
      <Programm>
        <Programmname>ffmpeg</Programmname>
        <Zieldateiname>%t-%T-%Z.mp4</Zieldateiname>
        <Programmpfad>/Applications/MediathekView.app/Contents/Resources/ffmpeg</Programmpfad>
        <Programmschalter>-user_agent '#{user_agent}' -i %f -c copy -bsf:a aac_adtstoasc **</Programmschalter>
        <Praefix>http</Praefix>
        <Suffix>m3u8</Suffix>
        <Restart>false</Restart>
      </Programm>
      <Programm>
        <Programmname>VLC</Programmname>
        <Zieldateiname>%t-%T-%Z.ts</Zieldateiname>
        <Programmpfad>/Applications/VLC.app/Contents/MacOS/VLC</Programmpfad>
        <Programmschalter>%f :sout=#standard{access=file,mux=ts,dst=**} -I dummy --play-and-exit:http-user-agent='#{user_agent}'</Programmschalter>
      </Programm>
      <Programmset>
        <Name>Mac Abspielen</Name>
        <Abspielen>true</Abspielen>
        <Speichern>false</Speichern>
        <Button>true</Button>
        <Abo>false</Abo>
        <max-Laenge>25</max-Laenge>
        <Beschreibung>Standardset zum direkten Abspielen der Filme</Beschreibung>
      </Programmset>
      <Programm>
        <Programmname>Vlc</Programmname>
        <Programmpfad>/Applications/VLC.app/Contents/MacOS/VLC</Programmpfad>
        <Programmschalter>%f --play-and-exit:http-user-agent='#{user_agent}'</Programmschalter>
      </Programm>
    </Mediathek>
  XML
end
