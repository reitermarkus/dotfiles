# frozen_string_literal: true

task :telegram do
  defaults 'ru.keepcoder.Telegram' do
    write 'AutomaticDashSubstitutionEnabledTGGrowingTextView', false
    write 'AutomaticDashSubstitutionEnabledTGMessagesTextView', false
    write 'AutomaticQuoteSubstitutionEnabledTGGrowingTextView', false
    write 'AutomaticQuoteSubstitutionEnabledTGMessagesTextView', false
  end

  capture '/usr/bin/killall', 'cfprefsd'
end
