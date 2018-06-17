task :arduino do
  arduino_preferences = Pathname('~/Library/Arduino15/preferences.txt').expand_path

  arduino_sketchbook_dir = Pathname('~/Documents/Arduino').expand_path

  arduino_preferences.dirname.mkpath

  add_line_to_file arduino_preferences, "sketchbook.path=#{arduino_sketchbook_dir}"
  arduino_sketchbook_dir.mkpath

  add_line_to_file arduino_preferences, 'editor.languages.current=de_DE'
  add_line_to_file arduino_preferences, 'editor.linenumbers=true'

  add_line_to_file arduino_preferences, 'boardsmanager.additional.urls=http://arduino.esp8266.com/stable/package_esp8266com_index.json'
end
