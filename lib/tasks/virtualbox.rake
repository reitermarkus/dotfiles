task :virtualbox => [:'brew:casks_and_formulae'] do
  # VirtualBox VM Directory
  next unless which 'VBoxManage'
  command 'VBoxManage', 'setproperty', 'machinefolder', File.expand_path('~/Library/Caches/VirtualBox/Virtual Machines')
end
