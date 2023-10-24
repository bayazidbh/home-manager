{ config, pkgs, ... }:
{

systemd.user.tmpfiles.rules = [
  "d ${config.home.homeDirectory}/Storage"
  "d ${config.home.homeDirectory}/Storage/Data"
  "d ${config.home.homeDirectory}/.icons"
  "d ${config.xdg.configHome}/heroic"
  # "C+ ${config.home.homeDirectory} - - - - ${config.xdg.configHome}/home-manager/default/config/skel/"
  "C+ ${config.home.homeDirectory}/.fonts - - - - ${config.xdg.configHome}/home-manager/default/config/fonts/fonts"
  "C+ ${config.xdg.dataHome}/fonts - - - - ${config.xdg.configHome}/home-manager/default/config/fonts/fonts"
  "C+ ${config.xdg.dataHome}/fontconfig - - - - ${config.xdg.configHome}/home-manager/default/config/fonts/fontconfig"
  "C+ ${config.xdg.configHome}/fontconfig - - - - ${config.xdg.configHome}/home-manager/default/config/fonts/fontconfig"
  "C+ ${config.xdg.dataHome}/icons - - - - ${config.xdg.configHome}/home-manager/default/config/icons/"
  "C+ ${config.home.homeDirectory}/.icons - - - - ${config.xdg.configHome}/home-manager/default/config/icons/"
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

home.file."wavebox-wayland" = {
  enable = true;
  target = ".local/bin/wavebox-wayland";
  executable = true;
  text = ''
    #!/usr/bin/bash

    flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --enable-features=UseOzonePlatform,Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,WaylandWindowDecoration,VaapiVideoEncoder,UseSkiaRenderer,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --ozone-platform=wayland --force-dark-mode
    '';
  };

home.file."wavebox-dark-x11" = {
  enable = true;
  target = ".local/bin/wavebox-dark-x11";
  executable = true;
  text = ''
    #!/usr/bin/bash

    flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --enable-features=Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --force-dark-mode
    '';
  };

home.file."spotify-adblock" = {
  enable = true;
  target = ".local/bin/spotify-adblock";
  executable = true;
  text = ''
    #!/bin/bash

    # Define the paths
    adblock_so_file="${config.home.sessionVariables.XDG_BIN_HOME}/spotify-adblock.so"
    spotify_adblock_so_url="https://github.com/abba23/spotify-adblock/releases/download/v1.0.3/spotify-adblock.so"
    spotify_flatpak_command="flatpak run --command=sh com.spotify.Client -c 'eval \"\$(sed s#LD_PRELOAD=#LD_PRELOAD=${config.home.sessionVariables.XDG_BIN_HOME}/spotify-adblock.so:#g /app/bin/spotify)\"'"

    # Check if the spotify-adblock.so file exists in ~/.local/bin
    if [ -f "$adblock_so_file" ]; then
        # If it exists, run Spotify with adblock
        echo "Running Spotify with adblock..."
        eval "$spotify_flatpak_command"
    else
        # If it doesn't exist, download it with aria2c
        echo "Spotify adblock file not found. Downloading..."
        aria2c -d ${config.home.sessionVariables.XDG_BIN_HOME} -o "spotify-adblock.so" $spotify_adblock_so_url

        # Check if the download was successful
        if [ -f "$adblock_so_file" ]; then
            # Run Spotify with adblock
            echo "Running Spotify with adblock..."
            eval "$spotify_flatpak_command"
        else
            echo "Failed to download Spotify adblock file."
        fi
    fi

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

# use nix-shell to provide certain packages

home.file."bottles" = {
  enable = true;
  target = ".local/bin/bottles";
  executable = true;
  text = ''
    #!/bin/bash

    binary="~/.nix-profile/bin/bottles"

    # Check if `~/.nix-profile/bin/bottles` exists and is executable
    if [ -x "$binary" ]; then
        # If it exists and is executable, execute it
        "$binary"
    else
        # If it doesn't exist, run `nix-shell -p bottles-unwrapped`
        echo "bottles not found in ~/.nix-profile/bin. Running nix-shell..."
        nix-shell -p bottles-unwrapped
    fi

    '';
  };

home.file."heroic" = {
  enable = true;
  target = ".local/bin/heroic";
  executable = true;
  text = ''
    #!/bin/bash

    binary="~/.nix-profile/bin/heroic"

    # Check if `~/.nix-profile/bin/bottles` exists and is executable
    if [ -x "$binary" ]; then
        # If it exists and is executable, execute it
        "$binary"
    else
        # If it doesn't exist, run `nix-shell -p bottles-unwrapped`
        echo "bottles not found in ~/.nix-profile/bin. Running nix-shell..."
        nix-shell -p heroic-unwrapped
    fi

    '';
  };

home.file."setup-distrobox-all" = {
  enable = true;
  target = ".local/bin/setup-distrobox-all";
  executable = true;
  text = ''
    #! /bin/bash

    podman image pull quay.io/toolbx-images/archlinux-toolbox:latest
    podman image pull quay.io/toolbx-images/ubuntu-toolbox:latest
    podman image pull -y registry.fedoraproject.org/fedora-toolbox:latest

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

    env SHELL=/bin/bash distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:latest --name ubuntu-latest --home ${config.xdg.userDirs.documents}/container/ubuntu-latest
    distrobox start ubuntu-latest

  '';
};

home.file."setup-distrobox-fedora" = {
  enable = true;
  target = ".local/bin/setup-distrobox-fedora";
  executable = true;
  text = ''
    #! /bin/bash

    env SHELL=/bin/zsh distrobox create --image registry.fedoraproject.org/fedora-toolbox:latest --name fedora --home ${config.xdg.userDirs.documents}/container/fedora
    distrobox enter fedora -- sudo dnf install -y dnf5 https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  '';
};
home.file."setup-distrobox-arch" = {
  enable = true;
  target = ".local/bin/setup-distrobox-arch";
  executable = true;
  text = ''
  #! /bin/bash

  env SHELL=/bin/fish distrobox create --image quay.io/toolbx-images/archlinux-toolbox:latest --name arch --home ${config.xdg.userDirs.documents}/container/arch ; \
  distrobox enter arch -- sudo pacman -Su --noconfirm nano ; \
  distrobox enter arch -- sudo pacman-key --init ; \
  distrobox enter arch -- sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com ; \
  distrobox enter arch -- sudo pacman-key --lsign-key 3056513887B78AEB ; \
  distrobox enter arch -- sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' ; \
  distrobox enter arch -- sh -c "echo -e '[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf" ; \
  distrobox enter arch -- sh -c "echo -e '\nen_SG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8\nid_ID.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen"
  distrobox enter arch -- sudo pacman -Syu --noconfirm glibc base-devel paru pipewire-jack pipewire-pulse pipewire-alsa wireplumber
  distrobox enter arch -- paru -Syyu --noconfirm --skipreview archisteamfarm-bin
  git clone https://aur.archlinux.org/gazou-git.git /tmp/gazou-git
  cd /tmp/gazou-git
  sed -i 's/-DGUI=ON/-DGUI=OFF/' /tmp/gazou-git/PKGBUILD
  distrobox enter arch -- makepkg -si --noconfirm
  distrobox enter arch -- env HOME=/home/fenglengshun distrobox-export --bin /usr/sbin/gazou

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

home.file."renpy" = {
  enable = true;
  target = ".local/bin/renpy";
  executable = true;
  text = ''
    #!/bin/bash

    # Specify the RenPy version you want to use
    version="8.1.3"

    # Define the paths
    renpy_dir="${config.home.sessionVariables.XDG_BIN_HOME}/renpy-bin"
    renpy_script="$renpy_dir/renpy-$version-sdk/renpy.sh"
    download_command="aria2c https://www.renpy.org/dl/$version/renpy-$version-sdk.tar.bz2 -d ~/Downloads && tar -xjf ~/Downloads/renpy-$version-sdk.tar.bz2 -C $renpy_dir"
    project_dir="${config.home.homeDirectory}/Applications/renpy"

    # Check if the RenPy directory exists for your projects

    if [ ! -d "$project_dir" ]; then
        echo "Creating project directory: $project_dir"
        mkdir -p "$project_dir"
        git clone git@github.com:bayazidbh/renpy-cold-tea.git "$project_dir/cold_tea"
    else
        for dir in "$project_dir"/*; do
            if [ -d "$dir/.git" ]; then
                echo "Updating Git repository in $dir"
                git -C "$dir" pull
            fi
        done
    fi

    # Check if the RenPy directory exists, and if not, create it
    if [ ! -d "$renpy_dir" ]; then
        echo "Creating RenPy directory: $renpy_dir"
        mkdir -p "$renpy_dir"
    fi

    # Check if the RenPy script exists and is executable
    if [ -x "$renpy_script" ]; then
        # If it exists and is executable, execute it
        "$renpy_script"
    else
        # If it doesn't exist or is not executable, download and extract RenPy
        if [ ! -f "$renpy_script" ]; then
            # Download and extract RenPy
            echo "RenPy script not found. Downloading and extracting..."
            eval $download_command
        fi

        # Make the script executable
        chmod +x "$renpy_script"

        # Execute the script
        "$renpy_script"
    fi

  '';
};

xdg.desktopEntries = {
  "RenPy" = {
    name = "Ren\'Py";
    comment = "Visual Novel Engine";
    startupNotify = true;
    exec = "${config.home.sessionVariables.XDG_BIN_HOME}/renpy";
    terminal = false;
    icon = "${config.xdg.dataHome}/icons/renpy.ico";
    type = "Application";
    categories = [ "Development" "Game" ];
    settings = {
      Keywords = "renpy;";
      };
    };
  "spotify-adblock" = {
    type = "Application";
    name = "Spotify (adblock)";
    genericName = "Music Player";
    icon= "com.spotify.Client";
    exec="${config.home.sessionVariables.XDG_BIN_HOME}/spotify-adblock";
    terminal=false;
    mimeType = [ "x-scheme-handler/spotify" ];
    categories = [ "Audio" "Music" "Player" "AudioVideo" ];
    settings={
      StartupWMClass="spotify";
      };
    };
  };
}
