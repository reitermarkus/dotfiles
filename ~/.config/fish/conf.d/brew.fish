# This file was created automatically, do not edit it directly.

source (brew command-not-found-init 2>/dev/null)

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
  if test (count $argv) -eq 1
    set -l dir (command brew --repository $argv[1])
    cd $dir
    test -d Casks;   and cd Casks
    test -d Formula; and cd Formula
  else
    cd (command brew --repository)/Library/Homebrew
  end
  return $status
end
