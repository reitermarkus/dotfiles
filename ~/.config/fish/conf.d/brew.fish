# This file was created automatically, do not edit it directly.

if set -l brew_command_init (brew command-not-found-init 2>&-)
  source "$brew_command_init"
end

if test (type -t brew) = function
  functions -c brew __brew_cd
  function brew
    if test (count $argv) -ge 1; and test "$argv[1]" = cd
      set --erase argv[1]
      brew_cd $argv
    else
      __brew_cd $argv
    end
  end
else
  function brew
    if test (count $argv) -ge 1; and test "$argv[1]" = cd
      set --erase argv[1]
      brew_cd $argv
    else
      command brew $argv
    end
  end
end

function brew_cd
  if not set -q __homebrew_repo
    set -U __homebrew_repo (command brew --repository)
  end

  if test (count $argv) -eq 1
    set -l user 'homebrew'
    set -l repo $argv[1]

    if string match -r '/' $argv[1]
      set -l tap (string split / $argv[1])
      set user $tap[1]
      set repo $tap[2]
    end

    cd "$__homebrew_repo/Library/Taps/$user/homebrew-$repo"
  else
    cd "$__homebrew_repo/Library/Homebrew"
  end

  return $status
end
