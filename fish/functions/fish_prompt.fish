function fish_prompt

  set -l last_status $status

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  set_color $fish_color_cwd
  printf '%s'  (prompt_pwd)
  set_color normal

  set_color $fish_color_comment
  printf '%s' (__fish_git_prompt)
  set_color normal

  if not test $last_status -eq 0
    set_color $fish_color_error
  end

  echo -n ' $ '

end
