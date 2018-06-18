require 'defaults'

task :hazel do
  defaults 'com.noodlesoft.Hazel' do
    write 'ScanInvisibles', true
    write 'ShowStatusInMenuBar', true
    write 'UpdateCheckFrequency', 1
  end
end
