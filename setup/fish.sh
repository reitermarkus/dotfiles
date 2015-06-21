# Change shell to “fish”.

if hash fish; then

  if ! cat /etc/shells | grep `which fish` &>/dev/null; then
    echo `which fish` | sudo tee -a /etc/shells > /dev/null
  fi

  if [[ ! "$SHELL" == *"/fish" ]]; then
    chsh -s `which fish`
  fi

fi

mkdir -p ~/.config/fish/
