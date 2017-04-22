# Custom Paths

export PATH="/usr/local/sbin:$PATH"

/bin/mkdir -p "$HOME/.config/git/commands"
export PATH="$HOME/.config/git/commands:$PATH"


# Ruby

export RBENV_ROOT="$HOME/.config/rbenv"

/bin/mkdir -p "$RBENV_ROOT/shims"
export PATH="$RBENV_ROOT/shims:$PATH"

export BUNDLE_PATH="$HOME/.config/bundle"
/bin/mkdir -p "$BUNDLE_PATH"
/bin/ln -sfn .config/bundle "$HOME/.bundle"


# Homebrew

export HOMEBREW_CASK_OPTS='--appdir=/Applications --dictionarydir=/Library/Dictionaries --colorpickerdir=/Library/ColorPickers --prefpanedir=/Library/PreferencePanes --qlplugindir=/Library/QuickLook --screen_saverdir=/Library/Screen\ Savers'
export HOMEBREW_DEVELOPER='1'
export HOMEBREW_GITHUB_API_TOKEN='0e3924d278578977b3bd88980c71877e0c426184'
