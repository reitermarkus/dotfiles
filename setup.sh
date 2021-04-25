#!/usr/bin/env bash

# After running this script, set up a VNC password:
# x11vnc -storepasswd ~/.vnc/passwd

cat <<EOS | sudo tee /etc/systemd/network/20-wired.network
[Match]
Name=ens18

[Network]
DHCP=yes

[DHCPv4]
UseDomains=true

[IPv6AcceptRA]
UseDomains=yes
EOS
sudo systemctl enable --now systemd-networkd

sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl enable --now systemd-resolved
sudo sed -i -E 's/^#(ResolveUnicastSingleLabel=).*/\1yes/' /etc/systemd/resolved.conf

sudo pacman -Syu --noconfirm base-devel git sed

sudo sed -i -E 's/^(GRUB_TIMEOUT=).*/\10/' /etc/default/grub
sudo sed -i -E 's/^(GRUB_TIMEOUT_STYLE=).*/\1hidden/' /etc/default/grub

pushd /tmp
git clone https://aur.archlinux.org/yay-bin.git
pushd yay-bin
makepkg -sri --noconfirm
popd
rm -rf yay-bin
popd

sudo pacman -Syu --noconfirm pulseaudio
systemctl --user enable --now pulseaudio

sudo mkdir -p /etc/pulse/daemon.conf.d
cat <<EOS | sudo tee /etc/pulse/daemon.conf.d/surround.conf
remixing-produce-lfe = yes
remixing-consume-lfe = yes
lfe-crossover-freq = 120

default-sample-rate = 48000
default-sample-channels = 6
EOS

sudo pacman -Syu --noconfirm lightdm

sudo mkdir -p /etc/lightdm/lightdm.conf.d
cat <<EOS | sudo tee /etc/lightdm/lightdm.conf.d/autologin.conf
[Seat:*]
autologin-user=plex
autologin-session=xinitrc
EOS

sudo pacman -Syu --noconfirm x11vnc
yay -Syu --noconfirm plex-media-player

sed -n -E '/^twm/q;p' /etc/X11/xinit/xinitrc > ~/.xinitrc
cat <<EOS >> ~/.xinitrc
# Turn off screensaver.
xset s off

# Turn off screen energy saving.
xset -dpms

# Set resolution.
xrandr > /tmp/xrandr.log
xrandr --output Virtual-1 --mode 1920x1080
xrandr --output HDMI-1 --mode 1920x1080
xrandr --output HDMI-2 --mode 1920x1080

# Set audio output profile.
pacmd set-card-profile 0 output:hdmi-surround-extra3
# pactl set-sink-formats 0 "pcm; ac3-iec61937; dts-iec61937; eac3-iec61937"

if ! pgrep x11vnc; then
  x11vnc -display :0 -usepw -forever -loop -repeat -nodpms -rfbport 5900 -rfbportv6 5900 &> /tmp/x11vnc.log &
fi

exec plexmediaplayer
EOS
chmod +x ~/.xinitrc

yay -Syu --noconfirm shairport-sync

sed -E '/^After=/d;/^Requires=/d;/^Wants=/d;s|^(ExecStart=/usr/bin/shairport-sync)|\1 --use-stderr --verbose \nRestart=always|;/^User=/d;/^Group=/d;s/^(WantedBy=).*/\1default.target/' /usr/lib/systemd/system/shairport-sync.service | sudo tee /usr/lib/systemd/user/shairport-sync.service

if ! [ -f /etc/shairport-sync.conf.sample ]; then
  sudo cp /etc/shairport-sync.conf /etc/shairport-sync.conf.sample
fi

cat <<EOS | sudo tee /etc/shairport-sync.conf
general = {
  name = "Büro";
  output_backend = "pa";
};
EOS

sudo systemctl enable --now avahi-daemon
systemctl --user enable --now shairport-sync
