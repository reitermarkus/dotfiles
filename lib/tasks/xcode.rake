namespace :xcode do
  desc 'Accept the Xcode License Agreement'
  task :accept_license do
    command sudo, 'xcodebuild', '-license', 'accept'
  end
end
