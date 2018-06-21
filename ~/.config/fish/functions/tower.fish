# This file was created automatically, do not edit it directly.

if which gittower ^&- >&-
  function tower --wraps gittower
    for repo in $argv
      set -l repo_root (git -C "$repo" rev-parse --show-toplevel ^&-)
      and gittower "$repo_root"
      or gittower "$repo"
    end
  end
end
