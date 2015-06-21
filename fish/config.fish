if status --is-login


  # Greeting

  set --erase fish_greeting


  # Custom Paths

  set -x PATH /usr/local/sbin $PATH
#  set -x PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
#  set -x PATH /usr/local/opt/gnu-getopt/bin $PATH


  # Editor

  set -x EDITOR 'open -a Coda\ 2'
  set -x HOMEBREW_EDITOR $EDITOR

  alias edit=$EDITOR


  # Aliases

  alias brupgrade='brew update; and brew upgrade --all'


  # Colors

  set -U fish_color_autosuggestion ff005f
  set -U fish_color_command ff005f
  set -U fish_color_comment 6c6c6c
  set -U fish_color_cwd 005fff
  set -U fish_color_cwd_root af0000
  set -U fish_color_error normal\x1e\x2d\x2dbold
  set -U fish_color_escape normal
  set -U fish_color_history_current normal
  set -U fish_color_host \x2do\x1ecyan
  set -U fish_color_match cyan
  set -U fish_color_normal normal
  set -U fish_color_operator cyan
  set -U fish_color_param 005fff
  set -U fish_color_quote 6600dd
  set -U fish_color_redirection 875f5f
  set -U fish_color_search_match \x2d\x2dbackground\x3dpurple
  set -U fish_color_status red
  set -U fish_color_user \x2do\x1egreen
  set -U fish_color_valid_path \x2d\x2dunderline
  set -U fish_pager_color_completion normal
  set -U fish_pager_color_description 555\x1eyellow
  set -U fish_pager_color_prefix cyan
  set -U fish_pager_color_progress cyan


  # OpenWrt

  set openwrt_dir /Volumes/Openwrt/openwrt
  set openwrt_bin $openwrt_dir/staging_dir/host/bin
  if test -d $openwrt_dir
    alias openwrt='cd /Volumes/OpenWrt/openwrt/'
#    if test -d $openwrt_bin
#      set -x PATH $openwrt_bin $PATH
#    end
  end


end
