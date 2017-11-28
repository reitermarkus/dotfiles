defaults_dnsmasq() {

  local dnsmasq_conf="$(brew --prefix)/etc/dnsmasq.conf"

  if ! /usr/bin/grep --quiet '^address=/.localhost/127.0.0.1$' "${dnsmasq_conf}"; then
    sed -i '' -E
      '/^#address=\/double-click.net\/127.0.0.1/a\
       address=/.localhost/127.0.0.1\
      ' "${dnsmasq_conf}"
  fi

  sudo /bin/mkdir -p /etc/resolver
  echo "nameserver 127.0.0.1" | sudo -E -- /usr/bin/tee /etc/resolver/localhost >/dev/null

}
