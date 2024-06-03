task :kinto do
  install_script = capture 'curl', '-fsSL', 'https://raw.githubusercontent.com/rbreaves/kinto/HEAD/install/linux.sh'
  command sudo, 'bash', '-c', install_script
end
