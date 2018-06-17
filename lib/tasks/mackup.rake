task :mackup do
  mackup_cfg = File.expand_path('~/.mackup.cfg')

  File.write mackup_cfg, <<~CFG
    [storage]
    engine = dropbox
    directory = Sync/~
  CFG

  command 'mackup', 'restore', '--force'
  command 'mackup', 'backup', '--force'
end
