#!/usr/bin/env bash

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

sudo sed -i -E 's/^; (remixing-produce-lfe =).*/\1 yes/' /etc/pulse/daemon.conf
sudo sed -i -E 's/^; (remixing-consume-lfe =).*/\1 yes/' /etc/pulse/daemon.conf
sudo sed -i -E 's/^; (lfe-crossover-freq =).*/\1 120/' /etc/pulse/daemon.conf
sudo sed -i -E 's/^; (default-sample-rate =).*/\1 48000/' /etc/pulse/daemon.conf
sudo sed -i -E 's/^; (default-sample-channels =).*/\1 6/' /etc/pulse/daemon.conf

sudo pacman -Syu --noconfirm lightdm

sudo sed -i -E 's/^#(autologin-user=).*/\1plex/' /etc/lightdm/lightdm.conf
sudo sed -i -E 's/^#(autologin-session=).*/\1xinitrc/' /etc/lightdm/lightdm.conf

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
  x11vnc -display :0 -auth guess -rfbauth ~/.vnc/passwd -forever -loop -repeat -nodpms -rfbport 5900 -rfbportv6 5900 &> /tmp/x11vnc.log &
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
