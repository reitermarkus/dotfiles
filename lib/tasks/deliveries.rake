# frozen_string_literal: true

task :deliveries do
  defaults 'com.junecloud.mac.Deliveries' do
    write 'JUNMenuBarMode', true
    write 'JUNStartAtLogin', true
  end
end
