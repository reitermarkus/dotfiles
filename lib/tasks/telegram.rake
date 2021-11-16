# frozen_string_literal: true

require 'defaults'
require 'killall'

task :telegram do
  defaults 'ru.keepcoder.Telegram' do
    write 'AutomaticDashSubstitutionEnabledTGGrowingTextView', false
    write 'AutomaticDashSubstitutionEnabledTGMessagesTextView', false
    write 'AutomaticQuoteSubstitutionEnabledTGGrowingTextView', false
    write 'AutomaticQuoteSubstitutionEnabledTGMessagesTextView', false
  end

  killall 'cfprefsd'
end
