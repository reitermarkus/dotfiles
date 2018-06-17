namespace :rapidclick do
  task :defaults do
    puts ANSI.blue { 'Configuring RapidClick …' }

    defaults 'com.pilotmoon.rapidclick' do
      # Disable Welcome Message
      write 'HasRunBefore', true

      # Keyboard Shortcut ⇧⌘C (Shift-Cmd-C)
      write 'StartStopKey', { 'modifiers' => 768, 'keyCode' => 8 }
    end
  end
end
