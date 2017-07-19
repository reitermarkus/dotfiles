# This file was created automatically, do not edit it directly.

alias rm='rm -i' # Ask before removing files.

alias +x='chmod +x'

# OCaml
alias ocaml='rlwrap ocaml'

# PlistBuddy
alias plistbuddy='/usr/libexec/PlistBuddy'

# Postgres
alias pg-start 'pg_ctl start -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log'
alias pg-stop 'pg_ctl stop -s -m fast -D /usr/local/var/postgres'

# Editor
export EDITOR='mate -w'
alias edit="mate"

# Finder
alias finder 'open -a Finder'
alias .DS_Store 'find . -name .DS_Store'
alias ds_store .DS_Store
alias openwithclean '/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -all user,local,system -v'

# Safari
alias safari 'open -a Safari'

# Git Tower
if which gittower > /dev/null
  function tower
    for repo in $argv
      set -l repo_root (git -C "$repo" rev-parse --show-toplevel ^ /dev/null)
      and gittower "$repo_root"
      or gittower "$repo"
    end
  end

  alias tedit 'tower $argv; and edit'
end
