# frozen_string_literal: true

require 'macos'

task :docker => :'brew:formulae_and_casks' do
  puts ANSI.blue { 'Configuring Docker …' }
end
