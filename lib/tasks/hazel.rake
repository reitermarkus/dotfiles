require 'defaults'

namespace :hazel do
  task :defaults do
    defaults 'com.noodlesoft.Hazel' do
      write 'ScanInvisibles', true
      write 'ShowStatusInMenuBar', true
      write 'UpdateCheckFrequency', 1
    end
  end
end
