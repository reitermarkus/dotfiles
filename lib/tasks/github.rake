# frozen_string_literal: true

task :github do
  add_line_to_file fish_environment('github'),
                   'test -e ~/.config/github/token; and read -x GITHUB_TOKEN < ~/.config/github/token'
  add_line_to_file bash_environment,
                   '[ -e ~/.config/github/token ] && read GITHUB_TOKEN < ~/.config/github/token && export GITHUB_TOKEN'
end
