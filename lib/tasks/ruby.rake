namespace :ruby do
  task :bundler do
    if capture('gem list --no-versions bundler').strip == 'bundler'
      puts ANSI.green { 'Bundler is already installed.' }
    else
      puts ANSI.green { 'Installing Bundler …' }
      command 'gem', 'install', 'bundler'
    end
  end
end
