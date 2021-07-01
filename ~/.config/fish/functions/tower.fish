# This file was created automatically, do not edit it directly.

if which gittower 2>&- >&-
  function tower --wraps gittower
    for repo in $argv
      set -l repo_root (git -C "$repo" rev-parse --show-toplevel 2>&-)
      and gittower "$repo_root"
      or gittower "$repo"
    end
  end
end
