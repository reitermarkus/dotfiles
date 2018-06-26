require 'environment'

task :sccache => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Setting RUSTC_WRAPPER to `sccache` …' }
  add_line_to_file fish_environment, 'which sccache ^&- >&-; and set -x RUSTC_WRAPPER sccache'
  add_line_to_file bash_environment, 'which sccache 2>&1 >/dev/null && export RUSTC_WRAPPER="sccache"'

  ENV['RUSTC_WRAPPER'] = 'sccache'

  defaults 'com.macromates.TextMate' do
    write 'environmentVariables', [
      {
        'enabled' => true,
        'name' => 'RUSTC_WRAPPER',
        'value' => ENV['RUSTC_WRAPPER'],
      },
    ], add: true
  end
end
