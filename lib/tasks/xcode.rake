namespace :xcode do
  task :accept_license do
    command sudo, 'xcodebuild', '-license', 'accept'
  end
end
