# This file was created automatically, do not edit it directly.

abbr --add -- '+x' 'chmod +x'
abbr --add -- '-x' 'chmod -x'

# OCaml
alias ocaml='rlwrap ocaml'

# PlistBuddy
alias plistbuddy='/usr/libexec/PlistBuddy'

# Postgres
alias pg-start 'pg_ctl start -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log'
alias pg-stop 'pg_ctl stop -s -m fast -D /usr/local/var/postgres'

# Finder
alias finder 'open -R'
abbr --add .DS_Store 'find . -name .DS_Store'
alias ds_store .DS_Store
alias openwithclean '/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -all user,local,system -v'

# Safari
alias safari 'open -a Safari'

abbr --add rsync-up 'rsync --progress -auv --exclude .git'

# Development
alias dotfiles 'cd ~/Documents/Git-Repos/dotfiles/'
alias website 'cd ~/Documents/Git-Repos/reitermarkus.github.com/'

# Maintenance
alias syncsettings 'mackup --force restore; and mackup --force restore; and mackup --force backup'
