# home-manager files and quick device setup

```
cd ~/.config
git clone git@github.com:bayazidbh/home-manager.git && cd ${${_%%.git*}##*/}
```

## Nix Setup

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run github:nix-community/home-manager -- switch --flake github:bayazidbh/home-manager
```

```
echo "trusted-users = root fenglengshun" | sudo tee -a /etc/nix/nix.conf && sudo pkill nix-daemon
echo "substituters = https://cache.nixos.org https://nix-gaming.cachix.org https://chaotic-nyx.cachix.org https://ezkea.cachix.org \ntrusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4= nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" > ~/.config/nix/nix.conf

export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

EDITOR=kwrite home-manager edit
nix-shell -p cachix --run "cachix use ezkea"
cachix use nix-gaming
home-manager switch -b bak

nix-env --delete-generations old ; nix-store --gc ; nix-collect-garbage -d
nix-du -s=500MB | dot -Tpng > ~/Downloads/nix-store.png
```

## Setup Scripts

### All

<details><summary>All</summary><p>

#### create container home folders

```
mkdir -p ~/Documents/container/conty
mkdir -p ~/Documents/container/arch
ln -sifv $HOME/Documents/Private/Apps/Linux/config/ArchiSteamFarm-config ~/Documents/container/arch/
```

#### link emulator paths to default xdg paths

```
ln -sifv $HOME/Games/Emulation/Nintendo/emu/yuzu/config $HOME/.config/yuzu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/yuzu/data $HOME/.local/share/yuzu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/Ryujinx/config $HOME/.config/Ryujinx
ln -sifv $HOME/Games/Emulation/Nintendo/emu/citra-emu/config $HOME/.config/citra-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/citra-emu/data $HOME/.local/share/citra-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/dolphin-emu/config $HOME/.config/dolphin-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/dolphin-emu/data $HOME/.local/share/dolphin-emu
ln -sifv $HOME/Games/Emulation/Sony/emu/PCSX2/config $HOME/.config/PCSX2
ln -sifv $HOME/Games/Emulation/Sony/emu/rpcs3/config $HOME/.config/rpcs3
ln -sifv $HOME/Games/Emulation/Sony/emu/ppsspp/config $HOME/.config/ppsspp

ln -sifv $HOME/Games/Emulation/Nintendo/emu/yuzu/config $HOME/Documents/container/conty/.config/yuzu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/yuzu/data $HOME/Documents/container/conty/.local/share/yuzu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/Ryujinx/config $HOME/Documents/container/conty/.config/Ryujinx
ln -sifv $HOME/Games/Emulation/Nintendo/emu/citra-emu/config $HOME/Documents/container/conty/.config/citra-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/citra-emu/data $HOME/Documents/container/conty/.local/share/citra-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/dolphin-emu/config $HOME/Documents/container/conty/.config/dolphin-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/dolphin-emu/data $HOME/Documents/container/conty/.local/share/dolphin-emu
ln -sifv $HOME/Games/Emulation/Sony/emu/PCSX2/config $HOME/Documents/container/conty/.config/PCSX2
ln -sifv $HOME/Games/Emulation/Sony/emu/rpcs3/config $HOME/Documents/container/conty/.config/rpcs3
ln -sifv $HOME/Games/Emulation/Sony/emu/ppsspp/config $HOME/Documents/container/conty/.config/ppsspp
```

#### Import gpg

```
gpg --import ~/Storage/Data/Documents/bayazidbh-gpg.gpg
```

#### Make resilio-sync config

```
mkdir -p $HOME/.config/rslsync
cp -v ~/Documents/Private/Apps/Linux/config/rslsync.conf $HOME/.config/rslsync
sed -i 's/"device_name": "[^"]*"/"device_name": "'$(hostname)'"/g' $HOME/.config/rslsync/rslsync.conf
```

#### block MiHoYo telemetry in /etc/hosts

```
echo -e "# block mihoyo telemetry\n\n0.0.0.0 overseauspider.yuanshen.com\n0.0.0.0 log-upload-os.hoyoverse.com\n0.0.0.0 dump.gamesafe.qq.com\n0.0.0.0 public-data-api.mihoyo.com\n0.0.0.0 log-upload.mihoyo.com\n0.0.0.0 uspider.yuanshen.com\n0.0.0.0 sg-public-data-api.hoyoverse.com\n\n0.0.0.0 prd-lender.cdp.internal.unity3d.com\n0.0.0.0 thind-prd-knob.data.ie.unity3d.com\n0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com\n0.0.0.0 cdp.cloud.unity3d.com\n0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com" | sudo tee -a /etc/hosts
```

#### create horizontal mangohud bar

```
mkdir -p /home/fenglengshun/.config/MangoHud/ && echo -e "horizontal\nlegacy_layout=0\nhud_no_margin\nfont_size=25\ntable_columns=28\nbackground_alpha=0.5\ntime=1\ntime_format=%I:%M %p\ngpu_stats\ngpu_temp\ncpu_stats\ncpu_temp\nram\nvram\nfps\nframe_timing\nframetime\ntoggle_hud=F8\nresolution\nwine\nvulkan_driver" | tee ~/.config/MangoHud/MangoHud.conf
```

#### create plasma-restarter

```
mkdir -p ~/.local/bin/ && echo '#! /bin/bash\n\nkillall plasmashell & kwin --replace & kstart plasmashell & exit' | tee ~/.local/bin/restart-plasma && chmod +x ~/.local/bin/restart-plasma
```

</p></details>

### PC

<details><summary>PC</summary><p>

#### Link HDD to SSD

```
ln -sifv ~/Storage/Data/Applications ~/Applications
ln -sifv ~/Storage/Data/Media/Games ~/Games
ln -sifv ~/Storage/Data/Documents ~/Documents/Storage
ln -sifv ~/Storage/Data/Downloads ~/Downloads/Storage
ln -sifv ~/Storage/Data/Media ~/Documents/Media
ln -sifv ~/Storage/Data/Pictures/Archive ~/Pictures/Storage
ln -sifv ~/Storage/Data/Pictures/DCIM ~/Pictures/DCIM
ln -sifv ~/Storage/Data/Music/ ~/Music/Storage
ln -sifv ~/Storage/Data/Videos/ ~/Videos/Storage
```

#### Copy backed up Documents

```
cp -rfpv ~/Storage/Data/Documents/Work ~/Documents/Work
cp -rfpv ~/Storage/Data/Documents/Private ~/Documents/Private
```

#### restore input-remapper settings

```
mkdir -p ~/.config/
cp -rfpv ~/Storage/Data/Documents/Private/Linux/config/input-remapper-2 ~/.config/
```

</p></details>

### Laptop

<details><summary>Laptop</summary><p>

#### autocheck for kdeconnect devices

```
crontab -e
( crontab -l ; echo -e "# Check for kdeconnect devices\n*/2 * * * *     /usr/bin/kdeconnect-cli --refresh" ) | crontab -
```

</p></details>

## Distro specific

### Debian / Ubuntu

<details><summary>Debian / Ubuntu</summary><p>

```
libdbusmenu-qt5-2　libdbusmenu-gtk4 appmenu-gtk3-module appmenu-gtk2-module libdbusmenu-gtk3-4　locales-all

curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get && deb-get install quickemu quickgui teamviewer

sudo apt-get install python3 python3-pip python3-yaml python3-dateutil python3-pyqt5 python3-packaging python3-requests && sudo pip3 install bauh
```
</p></details>


### Fedora

<details><summary>Fedora</summary><p>

```
sudo dnf install --allowerasing --best zsh @Virtualization fish kio-admin icoutils applet-window-buttons nmap wsdd samba python3-input-remapper gtk3-classic avif-pixbuf-loader heif-pixbuf-loader qt-heif-image-plugin libheif libheif-freeworld libheif-tools

sudo dnf install dnf5 https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
```

</p></details>

### Arch

<details><summary>Arch</summary><p>

```
pacman -Syyu paru

paru -Syyu plasma5-applets-window-title applet-window-appmenu-git applet-window-buttons-git topgrade brave-bin spotify spotify-adblock-git python-spotdl freedownloadmanager teamviewer steamtinkerlaunch heroic-games-launcher-bin krename gtk3-classic virt-manager gameconqueror qtscrcpy soundux corectrl appmenu-gtk-module discover ttf-ibm-plex icoextract ttf-meslo-nerd-font-powerlevel10k icoutils unicode-emoji python-emoji noto-fonts-emoji-flag-git noto-color-emoji-fontconfig sunshine hunspell-en_us

paru -Syu --skipreview --noconfirm  applet-window-appmenu-git applet-window-buttons-git archisteamfarm-bin btrfs-compress btrfs-du discord-screenaudio plasma-hud-git libspeedhack-git nwjs-bin nwjs-ffmpeg-codecs-bin ceserver rmtrash sgdboop-bin

sudo pacman -S $(pacman -Qsq "^linux" | grep "^linux[0-9]*[-rt]*$" | awk '{print $1"-headers"}' ORS=' ')

performance tweaks: ananicy-cpp memavaild preload nohang uresourced prelockd irqbalance

gaming: noisetorch fancontrol-gui input-remapper droidcam steamtinkerlaunch mangohud gamemode goverlay replay-sorcery gamescope nyrna fastgame gameconqueror
``````
</p></details>

## Other Setups

<details><summary>Distrobox</summary><p>

### Distrobox

```
env SHELL=/bin/fish distrobox create --image quay.io/toolbx-images/archlinux-toolbox --name arch --home ~/Documents/container/arch
tide configure

pacman-key --init && pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com && pacman-key --lsign-key 3056513887B78AEB && pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' && echo '[chaotic-aur]' >> /etc/pacman.conf && echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf && echo 'en_SG.UTF-8 UTF-8' >> /etc/locale.gen && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen && echo 'id_ID.UTF-8 UTF-8' >> /etc/locale.gen && pacman -Syu --noconfirm glibc base-devel nano paru pipewire-jack pipewire-pulse pipewire-alsa

paru -Syu --skipreview --noconfirm nwjs-bin nwjs-ffmpeg-codecs-bin archisteamfarm-bin

---

env SHELL=/bin/bash distrobox create --image ubuntu:latest --name ubuntu-latest --home ~/Documents/container/ubuntu-latest

env SHELL=/home/fenglengshun/.nix-profile/bin/zsh distrobox create --image fedora:latest --name fedora --home ~/Documents/container/fedora
sudo dnf install dnf5 https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

distrobox create --root --init --image registry.opensuse.org/opensuse/tumbleweed:latest --name tumbleweed --home $XDG_DATA_HOME/distrobox/tumbleweed
https://github.com/89luca89/distrobox/blob/main/docs/posts/run_libvirt_in_distrobox.md
```

</p></details>


<details><summary>Fish-ified ZSH</summary><p>

### Fish-ified ZSH

```
sudo chsh -s /bin/zsh ; chsh -s /bin/zsh ; sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ; git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search ; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

kwrite ~/.zshrc
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
source ~/.zshrc
```

</p></details>

<details><summary>WhiteSur</summary><p>

### WhiteSur

#### Normal Install

- https://github.com/vinceliuice/WhiteSur-gtk-theme
- https://github.com/vinceliuice/WhiteSur-icon-theme
- https://github.com/vinceliuice/WhiteSur-kde
- https://github.com/vinceliuice/WhiteSur-cursors
- https://github.com/vinceliuice/Monterey-kde

```
mkdir -p /tmp/whitesur/whitesur

git clone https://github.com/vinceliuice/WhiteSur-gtk-theme /tmp/whitesur/WhiteSur-gtk-theme
/tmp/whitesur/WhiteSur-gtk-theme/install.sh -m -i -l standard -b default
/tmp/whitesur/WhiteSur-gtk-theme/tweaks.sh -F

git clone https://github.com/vinceliuice/WhiteSur-icon-theme /tmp/whitesur/WhiteSur-icon-theme
/tmp/whitesur/WhiteSur-icon-theme/install.sh

git clone https://github.com/vinceliuice/WhiteSur-kde /tmp/whitesur/WhiteSur-kde
/tmp/whitesur/WhiteSur-kde/install.sh
/tmp/whitesur/WhiteSur-kde/sddm/install.sh

git clone https://github.com/vinceliuice/WhiteSur-cursors /tmp/whitesur/WhiteSur-cursors
/tmp/whitesur/WhiteSur-cursors/install.sh

git clone https://github.com/vinceliuice/Monterey-kde /tmp/whitesur/Monterey-kde
/tmp/whitesur/Monterey-kde/install.sh
sudo /tmp/whitesur/Monterey-kde/sddm/install.sh
```

#### Icon options

```
--icon [standard|simple|gnome|ubuntu|tux|arch|manjaro|fedora|debian|void|opensuse|popos|mxlinux|zorin]
```

#### ublue Install

```
git clone git@github.com:bayazidbh/WhiteSur-gtk-theme.git ; git clone git@github.com:bayazidbh/WhiteSur-icon-theme.git ; git clone git@github.com:bayazidbh/WhiteSur-kde.git ; git clone git@github.com:bayazidbh/Monterey-kde.git ; git clone git@github.com:bayazidbh/WhiteSur-cursors.git
```

#### GNOME Install

```
/tmp/whitesur/WhiteSur-gtk-theme/tweaks --dash-to-dock -c dark ; sudo /tmp/whitesur/WhiteSur-gtk-theme/tweaks.sh -g --gdm-no-darken --no-blur -b default ;
```

</p></details>

### libvirt

<details><summary>xml</summary><p>

```
  <clock offset="localtime">
    <timer name="hpet" present="yes"/>
    <timer name="hypervclock" present="yes"/>
  </clock>

<disk type="file" device="disk">
      <driver name="qemu" type="qcow2"/>
      <source file="/home/fenglengshun/.local/share/libvirt/win11.qcow2"/>
      <target dev="vda" bus="virtio"/>
      <address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
</disk>
```
</p></details>

<details><summary>Command</summary><p>

```
$ sudo sed -i "s/#user = \"root\"/user = \"$(id -un)\"/g" /etc/libvirt/qemu.conf
$ sudo sed -i "s/#group = \"root\"/group = \"$(id -gn)\"/g" /etc/libvirt/qemu.conf
$ sudo usermod -a -G kvm $(id -un)
$ sudo usermod -a -G libvirt $(id -un)
$ sudo systemctl restart libvirtd

$ sudo ln -s /etc/apparmor.d/usr.sbin.libvirtd /etc/apparmor.d/disable/

$ sudo sed -i "s/\/usr\/libexec\/libvirt_leaseshelper m,/\/usr\/libexec\/libvirt_leaseshelper mr,/g" /etc/apparmor.d/usr.sbin.dnsmasq
$ mkdir -p ~/.config/libvirt
$ echo "uri_default = \"qemu:///system\"" >> ~/.config/libvirt/libvirt.conf
```

### Docker / Podman

</p></details>

<details><summary>Docker setup</summary><p>

```
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
podman run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /run/user/1000/podman/podman.sock:/var/run/docker.sock -v portainer_data:/data docker.io/portainer/portainer-ce:latest

# https://hub.docker.com/r/resilio/sync/
export DATA_FOLDER=/home/fenglengshun/rslsync
export WEBUI_PORT=30000
DATA_FOLDER=/home/fenglengshun/rslsync  WEBUI_PORT=30000 docker run -d --name Sync -p 30000:8888 -p 55555 -v /home/fenglengshun/rslsync:/mnt/sync -v /home/fenglengshun:/mnt/mounted_folders/fenglengshun -v /mnt/data:/mnt/mounted_folders/data --restart unless-stopped resilio/sync

docker pull docker.io/freshrss/freshrss
docker run -d --restart unless-stopped --log-opt max-size=10m -p 18080:80 -e TZ=Europe/Paris -e 'CRON_MIN=1,31' -v freshrss_data:/var/www/FreshRSS/data -v freshrss_extensions:/var/www/FreshRSS/extensions --name freshrss freshrss/freshrss

podman run -d --restart unless-stopped --log-opt max-size=10m -p 18080:80 -e TZ=Europe/Paris -e 'CRON_MIN=1,31' -v /home/fenglengshun/Documents/Private/Linux/config/freshrss/data:/var/www/FreshRSS/data -v /home/fenglengshun/Documents/Private/Linux/config/freshrss/extensions:/var/www/FreshRSS/extensions --name freshrss freshrss/freshrss
```

</p></details>

### Others

<details><summary>AppImage</summary><p>

- [Bauh](https://github.com/vinifmor/bauh#installation)
- [ScreenTranslator](https://github.com/OneMoreGres/ScreenTranslator/releases)

```
aria2c https://raw.githubusercontent.com/vinifmor/bauh/master/bauh/desktop/bauh.desktop
aria2c https://raw.githubusercontent.com/vinifmor/bauh-files/master/pictures/logo.svg
```

</p></details>
