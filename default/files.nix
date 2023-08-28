{ config, pkgs, ... }:
{

systemd.user.tmpfiles.rules = [
  "C+ ${config.xdg.dataHome}/applications/custom-applications - - - -  ${config.xdg.configHome}/home-manager/default/config/applications/actives"
  "L ${config.xdg.configHome}/opensnitchd - - - - ${config.xdg.configHome}/home-manager/default/config/opensnitchd"
  "L ${config.xdg.userDirs.documents}/Downloads - - - - ${config.xdg.userDirs.download}"
  "L ${config.xdg.userDirs.documents}/Music - - - - ${config.xdg.userDirs.music}"
  "L ${config.xdg.userDirs.documents}/Pictures - - - - ${config.xdg.userDirs.pictures}"
  "L ${config.xdg.userDirs.documents}/Videos - - - - ${config.xdg.userDirs.videos}"

];

home.file."resilio.conf" = {
  enable = true;
  target = ".config/rslsync/rslsync.conf";
  text = ''
    {

      "device_name": "${config.home.sessionVariables.HOST}",
      "storage_path" : "${config.xdg.configHome}/rslsync",
      "pid_file" : "${config.xdg.configHome}/rslsync/resilio.pid",
      "use_upnp" : true,
      "download_limit" : 0,
      "upload_limit" : 0,
      "directory_root" : "${config.home.homeDirectory}/",
      "webui" :
      {
        "listen" : "0.0.0.0:8888" // remove field to disable WebUI
      }

    }

    '';
};

home.file."installt-whitesur" = {
  enable = true;
  target = ".local/bin/install-whitesur";
  executable = true;
  text = ''
    #! /bin/bash

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
     /tmp/whitesur/Monterey-kde/sddm/install.sh
  '';
};

home.file."restart-plasma" = {
  enable = true;
  target = ".local/bin/restart-plasma";
  executable = true;
  text = ''
    #! /bin/bash
    killall plasmashell &
    kwin --replace &
    kstart plasmashell &
    disown
    exit
  '';
};


home.file."setup-distrobox-all" = {
  enable = true;
  target = ".local/bin/setup-distrobox-all";
  executable = true;
  text = ''
    #! /bin/bash

    ${config.home.sessionVariables.XDG_BIN_HOME}/setup-distrobox-ubuntu
    ${config.home.sessionVariables.XDG_BIN_HOME}/setup-distrobox-fedora
    ${config.home.sessionVariables.XDG_BIN_HOME}/setup-distrobox-arch

    '';
  };

home.file."setup-distrobox-ubuntu" = {
  enable = true;
  target = ".local/bin/setup-distrobox-ubuntu";
  executable = true;
  text = ''
    #! /bin/bash

    env SHELL=/bin/bash distrobox create --image ubuntu:latest --name ubuntu-latest --home ~/Documents/container/ubuntu-latest
    distrobox start ubuntu-latest

  '';
};

home.file."setup-distrobox-fedora" = {
  enable = true;
  target = ".local/bin/setup-distrobox-fedora";
  executable = true;
  text = ''
    #! /bin/bash

    env SHELL=/bin/zsh distrobox create --image fedora:latest --name fedora --home ~/Documents/container/fedora
    distrobox enter fedora -- sudo dnf install -y dnf5 https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  '';
};
home.file."setup-distrobox-arch" = {
  enable = true;
  target = ".local/bin/setup-distrobox-arch";
  executable = true;
  text = ''
  #! /bin/bash

  env SHELL=/bin/fish distrobox create --image quay.io/toolbx-images/archlinux-toolbox --name arch --home ~/Documents/container/arch ; \
  distrobox enter arch -- sudo pacman -Su --noconfirm nano ; \
  distrobox enter arch -- sudo pacman-key --init ; \
  distrobox enter arch -- sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com ; \
  distrobox enter arch -- sudo pacman-key --lsign-key 3056513887B78AEB ; \
  distrobox enter arch -- sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' ; \
  distrobox enter arch -- sh -c "echo -e '[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf" ; \
  distrobox enter arch -- sh -c "echo -e '\nen_SG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8\nid_ID.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen"
  distrobox enter arch -- sudo pacman -Syu --noconfirm glibc base-devel paru pipewire-jack pipewire-pulse pipewire-alsa

  '';
};

home.file."no-root-virt-manager" = {
  enable = true;
  target = ".local/bin/no-root-virt-manager";
  executable = true;
  text = ''
    sudo usermod -a -G kvm ${config.home.username}
    sudo usermod -a -G libvirt ${config.home.username}
  '';
};

home.file."NonSteamLaunchers.sh" = {
  enable = true;
  target = ".local/bin/NonSteamLaunchers.sh";
  executable = true;
  text = ''
    #! /bin/bash
    /bin/bash -c 'curl -Ls https://raw.githubusercontent.com/moraroy/NonSteamLaunchers-On-Steam-Deck/main/NonSteamLaunchers.sh | nohup /bin/bash'
  '';
};

home.file."libvirt.conf" = {
  enable = true;
  target = ".config/libvirt/libvirt.conf";
  text = ''
    uri_default = "qemu:///system"
  '';
};

home.file."nix.conf" = {
  enable = false;
  target = ".config/nix/nix.conf";
  text = ''
    substituters = https://cache.nixos.org https://nix-gaming.cachix.org https://chaotic-nyx.cachix.org https://ezkea.cachix.org
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4= nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=
  '';
};
}
