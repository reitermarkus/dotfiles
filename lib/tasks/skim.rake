# frozen_string_literal: true

require 'defaults'

task :skim do
  defaults 'net.sourceforge.skim-app' do
    write 'SKReopenLastOpenFiles', true
  end
end
