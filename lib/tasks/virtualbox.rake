task :virtualbox => [:'brew:casks_and_formulae'] do
  next unless which 'VBoxManage'

  # VirtualBox VM Directory
  command 'VBoxManage', 'setproperty', 'machinefolder', File.expand_path('~/Library/Caches/VirtualBox/Virtual Machines')
end
