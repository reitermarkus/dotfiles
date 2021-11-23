# frozen_string_literal: true

task :fork do
  puts ANSI.blue { 'Configuring Fork …' }

  defaults 'com.DanPristupov.Fork' do
    write 'gitInstanceType', 3 # /usr/local/bin/git
    write 'mergeTool', 5 # Araxis Merge
    write 'externalDiffTool', 5 # Araxis Merge
    write 'fetchSheetFetchAllRemotes', true
    write 'fetchSheetFetchAllTags', true
    write 'pullSheetRebase', true
    write 'pullSheetStashAndReapply', true
    write 'SUEnableAutomaticChecks', false
  end
end
