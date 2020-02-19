function docker --wraps docker
  if contains -- -h $argv || contains -- --help $argv || test (count $argv) = 0; else
    open -jga Docker

    while true
      set -l ping_status (curl --fail --unix-socket /var/run/docker.sock 'http://localhost/_ping' 2>&-)

      if test "$ping_status" = OK
        break
      else
        sleep 1
      end
    end
  end

  command docker $argv
end
