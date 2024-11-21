# frozen_string_literal: true

require 'macos'

task :docker => :'brew:formulae_and_casks' do
  puts ANSI.blue { 'Configuring Docker …' }

  if macos?
    fish_function = Pathname('~/.config/fish/functions/docker.fish').expand_path
    fish_function.dirname.mkpath
    fish_function.write <<~FISH
      # This file was created automatically, do not edit it directly.

      function docker --wraps docker
        if contains -- -h $argv || contains -- --help $argv || test (count $argv) = 0; else
          if ! pgrep Docker >&-
            open -jga Docker
          end

          while true
            set -l ping_status (curl --fail --unix-socket ~/.docker/run/docker.sock 'http://localhost/_ping' 2>&-)

            if test "$ping_status" = OK
              break
            else
              sleep 1
            end
          end
        end

        command docker $argv
      end
    FISH
  end
end
