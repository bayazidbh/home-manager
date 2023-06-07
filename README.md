# home-manager files and quick device setup

## nix-installer-scripts
https://github.com/dnkmmr69420/nix-installer-scripts

<details><summary>nix-installer-scripts</summary><p>

## Installers

### Regular installer for non-selinux systems

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/regular-installer.sh | bash
```

### Installer for selinux systems that aren't immutable (Fedora workstation, RHEL, centos stream, rocky alma or oracle linux)

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/regular-nix-installer-selinux.sh | bash
```

### Installer for rpm-ostree based systems like silverblue/kinoite/ublue

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/silverblue-nix-installer.sh | bash
```

### Installer for opensuse microos

first run this

```bash
sudo transactional-update run mksubvolume /nix
```

Reboot

Then run the script

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/nix-microos-installer.sh | bash
```

### Void linux installer

First check if curl is installed

```bash
sudo xbps-install -S curl
```
use the bash shell

```bash
bash
```

Install nix

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/nix-void-linux-installer.sh | bash
```

### [Nix inside distrobox installer and setup](https://github.com/dnkmmr69420/nix-installer-scripts/tree/main/nix-distrobox)


## Uninstallers

### Regular uninstaller for both non-selinux and selinux muttable systems

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/uninstaller-scripts/regular-uninstaller.sh | bash
```

### Silverblue nix uninstaller

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/uninstaller-scripts/silverblue-nix-uninstaller.sh | bash
```
  
</p></details>

```
echo "trusted-users = root fenglengshun" | sudo tee -a /etc/nix/nix.conf && sudo pkill nix-daemon
```

## Setup Scripts

## Other Setups

<details><summary>Distrobox</summary><p>

```
env SHELL=/home/fenglengshun/.nix-profile/bin/fish distrobox create --image archlinux:latest --name arch --home $XDG_DATA_HOME/distrobox/arch

pacman-key --init && pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com && pacman-key --lsign-key FBA220DFC880C036 && pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' && echo '[chaotic-aur]' >> /etc/pacman.conf && echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf && echo 'en_SG.UTF-8 UTF-8' >> /etc/locale.gen && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen && echo 'id_ID.UTF-8 UTF-8' >> /etc/locale.gen && pacman -Syu --noconfirm glibc base-devel nano paru pipewire-jack pipewire-pulse pipewire-alsa

paru -Syu --skipreview --noconfirm nwjs-bin nwjs-ffmpeg-codecs-bin archisteamfarm-bin

env SHELL=/home/fenglengshun/.nix-profile/bin/zsh distrobox create --root --init --image registry.opensuse.org/opensuse/tumbleweed:latest --name tumbleweed --home $XDG_DATA_HOME/distrobox/tumbleweed
```
  
</p></details>

### Fish-ified ZSH

```
sudo chsh -s /bin/zsh ; chsh -s /bin/zsh ; sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ; git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search ; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
```

### WhiteSur

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

```
--icon [standard|simple|gnome|ubuntu|tux|arch|manjaro|fedora|debian|void|opensuse|popos|mxlinux|zorin]
```

```
git clone git@github.com:bayazidbh/WhiteSur-gtk-theme.git ; git clone git@github.com:bayazidbh/WhiteSur-icon-theme.git ; git clone git@github.com:bayazidbh/WhiteSur-kde.git ; git clone git@github.com:bayazidbh/Monterey-kde.git ; git clone git@github.com:bayazidbh/WhiteSur-cursors.git
```

```
./tweaks --dash-to-dock -c dark ; sudo ./tweaks.sh -g --gdm-no-darken --no-blur -b default ;
```
