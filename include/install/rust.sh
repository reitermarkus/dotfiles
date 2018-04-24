install_rustup() {

  rustup-init -y --no-modify-path
  rustup update

  rustup component add rust-src

  if ! which racer &>/dev/null; then
    cargo install racer
  fi

}

