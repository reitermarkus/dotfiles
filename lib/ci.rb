def ci?
  ENV.key?('CI')
end

def travis?
  ENV['USER'] == 'travis'
end

def azure?
  ENV['USER'] == 'vsts'
end
