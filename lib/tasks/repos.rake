# frozen_string_literal: true

require 'pathname'
require 'shellwords'

task :repos => [:'brew:casks_and_formulae'] do
  repos_dir = Pathname('~/Repos').expand_path
  repos_dir.mkpath

  raise unless (tag = which 'tag')
  raise unless (git = which 'git')

  launchd_name = 'repos'
  launchd_plist = Pathname("~/Library/LaunchAgents/#{launchd_name}.plist").expand_path

  plist = {
    'Label' => launchd_name,
    'RunAtLoad' => true,
    'StartInterval' => 3600,
    'KeepAlive' => {
      'Crashed' => true,
      'SuccessfulExit' => false,
    },
    'ThrottleInterval' => 60,
    'ProgramArguments' => [
      '/bin/bash', '-c', <<-SH
        pushd #{repos_dir.to_s.shellescape}

        for repo in *; do
          porcelain_status="$(#{git.shellescape} -C "${repo}" status --porcelain)" || continue

          if [ -z "${porcelain_status}" ]; then
            if [[ "$(#{git.shellescape} -C "${repo}" rev-list --count --left-right "@{upstream}...HEAD")" == $'0\t0' ]]; then
              #{tag.shellescape} --set "Grün" "${repo}"
            else
              #{tag.shellescape} --set "Orange" "${repo}"
            fi
          else
            #{tag.shellescape} --set "Rot" "${repo}"
          fi
        done

        popd
      SH
    ],
    'StandardOutPath' => "/usr/local/var/log/#{launchd_name}.log",
    'StandardErrorPath' => "/usr/local/var/log/#{launchd_name}.log",
    'WatchPaths' => [repos_dir.to_s],
  }

  launchd_plist.dirname.mkpath
  launchd_plist.write plist.to_plist

  capture '/bin/launchctl', 'load', launchd_plist.to_path
end
