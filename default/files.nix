{ config, pkgs, ... }:
{

systemd.user.tmpfiles.rules = [
  "d ${config.home.homeDirectory}/Storage"
  "d ${config.home.homeDirectory}/Storage/Data"
  "d ${config.home.homeDirectory}/.icons"
  "d ${config.xdg.configHome}/heroic"
  "d ${config.home.homeDirectory}/.var/app/com.heroicgameslauncher.hgl/config/heroic"
  "d ${config.xdg.dataHome}/flatpak/"
  # "C+ ${config.home.homeDirectory} - - - - ${config.xdg.configHome}/home-manager/default/config/skel/"
  "C+ ${config.home.homeDirectory}/.fonts - - - - ${config.xdg.configHome}/home-manager/default/config/skel/.local/share/fonts"
  "C+ ${config.xdg.dataHome}/fonts - - - - ${config.xdg.configHome}/home-manager/default/config/skel/.local/share/fonts"
  "C+ ${config.xdg.dataHome}/fontconfig - - - - ${config.xdg.configHome}/home-manager/default/config/skel/.local/share/fontconfig"
  "C+ ${config.xdg.configHome}/fontconfig - - - - ${config.xdg.configHome}/home-manager/default/config/skel/.local/share/fontconfig"
  "C+ ${config.xdg.dataHome}/icons - - - - ${config.xdg.configHome}/home-manager/default/config/skel/.local/share/icons/"
  "C+ ${config.home.homeDirectory}/.icons - - - - ${config.xdg.configHome}/home-manager/default/config/skel/.local/share/icons/"
  "C+ ${config.xdg.dataHome}/applications/custom-applications - - - -  ${config.xdg.configHome}/home-manager/default/config/applications/actives"
  "L ${config.xdg.dataHome}/flatpak/overrides - - - - ${config.xdg.configHome}/home-manager/flatpak/overrides"
  "L ${config.xdg.configHome}/opensnitchd - - - - ${config.xdg.configHome}/home-manager/default/config/skel/.config/opensnitchd"
  "L ${config.xdg.userDirs.documents}/Downloads - - - - ${config.xdg.userDirs.download}"
  "L ${config.xdg.userDirs.documents}/Music - - - - ${config.xdg.userDirs.music}"
  "L ${config.xdg.userDirs.documents}/Pictures - - - - ${config.xdg.userDirs.pictures}"
  "L ${config.xdg.userDirs.documents}/Videos - - - - ${config.xdg.userDirs.videos}"
  # "L ${config.xdg.dataHome}/flatpak/app/org.winehq.Wine/current/active/export/share/applications/org.winehq.Wine.desktop - - - - ${config.xdg.configHome}/home-manager/flatpak/org.winehq.Wine.desktop"
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

    flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --enable-features=UseOzonePlatform,Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --ozone-platform-hint=auto --enable-wayland-ime
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
    /tmp/whitesur/WhiteSur-gtk-theme/install.sh -m -i fedora -l -b default
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

home.file."spotify-adblock-config" = {
  enable = true;
  target = ".config/spotify-adblock/config.toml";
  text = ''
    allowlist = [
        'localhost', # local proxies
        'audio-sp-.*\.pscdn\.co', # audio
        'audio-fa\.scdn\.co', # audio
        'audio4-fa\.scdn\.co', # audio
        'charts-images\.scdn\.co', # charts images
        'daily-mix\.scdn\.co', # daily mix images
        'dailymix-images\.scdn\.co', # daily mix images
        'heads-fa\.scdn\.co', # audio (heads)
        'i\.scdn\.co', # cover art
        'lineup-images\.scdn\.co', # playlists lineup images
        'merch-img\.scdn\.co', # merch images
        'misc\.scdn\.co', # miscellaneous images
        'mosaic\.scdn\.co', # playlist mosaic images
        'newjams-images\.scdn\.co', # release radar images
        'o\.scdn\.co', # cover art
        'pl\.scdn\.co', # playlist images
        'profile-images\.scdn\.co', # artist profile images
        'seeded-session-images\.scdn\.co', # radio images
        't\.scdn\.co', # background images
        'thisis-images\.scdn\.co', # 'this is' playlists images
        'video-fa\.scdn\.co', # videos
        '.*\.acast\.com', # podcasts
        'content\.production\.cdn\.art19\.com', # podcasts
        'rss\.art19\.com', # podcasts
        '.*\.buzzsprout\.com', # podcasts
        'chtbl\.com', # podcasts
        'platform-lookaside\.fbsbx\.com', # Facebook profile images
        'genius\.com', # lyrics (genius-spicetify)
        '.*\.googlevideo\.com', # YouTube videos (Spicetify Reddit app)
        '.*\.gvt1\.com', # Widevine download
        'content\.libsyn\.com', # podcasts
        'hwcdn\.libsyn\.com', # podcasts
        'traffic\.libsyn\.com', # podcasts
        'api.*-desktop\.musixmatch\.com', # lyrics (genius-spicetify)
        '.*\.podbean\.com', # podcasts
        'cdn\.podigee\.com', # podcasts
        'dts\.podtrac\.com', # podcasts
        'www\.podtrac\.com', # podcasts
        'www\.reddit\.com', # Reddit (Spicetify Reddit app)
        'audio\.simplecast\.com', # podcasts
        'media\.simplecast\.com', # podcasts
        'ap\.spotify\.com', # audio (access point)
        '.*\.ap\.spotify\.com', # access points
        'ap-.*\.spotify\.com', # access points
        'api\.spotify\.com', # client APIs
        'api-partner\.spotify\.com', # album/artist pages
        'xpui\.app\.spotify\.com', # user interface
        'apresolve\.spotify\.com', # access point resolving
        'clienttoken\.spotify\.com', # login
        '.*dealer\.spotify\.com', # websocket connections
        'image-upload.*\.spotify\.com', # image uploading
        'login.*\.spotify\.com', # login
        '.*-spclient\.spotify\.com', # client APIs
        'spclient\.wg\.spotify\.com', # client APIs, ads/tracking (blocked in blacklist)
        'audio-fa\.spotifycdn\.com', # audio
        'mixed-media-images\.spotifycdn\.com', # mix images
        'seed-mix-image\.spotifycdn\.com', # mix images
        'api\.spreaker\.com', # podcasts
        'download\.ted\.com', # podcasts
        'www\.youtube\.com', # YouTube (Spicetify Reddit app)
        'i\.ytimg\.com', # YouTube images (Spicetify Reddit app)
        'chrt\.fm', # podcasts
        'dcs.*\.megaphone\.fm', # podcasts
        'traffic\.megaphone\.fm', # podcasts
        'pdst\.fm', # podcasts
        'audio-ak-spotify-com\.akamaized\.net', # audio
        'audio-akp-spotify-com\.akamaized\.net', # audio
        'audio4-ak-spotify-com\.akamaized\.net', # audio
        'heads4-ak-spotify-com\.akamaized\.net', # audio (heads)
        '.*\.cloudfront\.net', # podcasts
        'audio4-ak\.spotify\.com\.edgesuite\.net', # audio
        'scontent.*\.fbcdn\.net', # Facebook profile images
        'audio-sp-.*\.spotifycdn\.net', # audio
        'dovetail\.prxu\.org', # podcasts
        'dovetail-cdn\.prxu\.org', # podcasts
    ]

    denylist = [
        'https://spclient\.wg\.spotify\.com/ads/.*', # ads
        'https://spclient\.wg\.spotify\.com/ad-logic/.*', # ads
        'https://spclient\.wg\.spotify\.com/gabo-receiver-service/.*', # tracking
    ]
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

home.file."wine-setup" = {
  enable = true;
  target = ".local/bin/wine-setup";
  executable = true;
  text = ''
    WINEPREFIX=${config.xdg.dataHome}/wineconty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh winetricks -q dxvk vkd3d corefonts cjkfonts
    WINEPREFIX=${config.xdg.dataHome}/wineconty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh ${config.xdg.userDirs.documents}/Private/Apps/Windows/RTP100/Setup.exe
    WINEPREFIX=${config.xdg.dataHome}/wineconty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh ${config.xdg.userDirs.documents}/Private/Apps/Windows/RTP100/RGSS-RTP Standard.exe
    WINEPREFIX=${config.xdg.dataHome}/wineconty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh ${config.xdg.userDirs.documents}/Private/Apps/Windows/RTP100/RPGVX_RTP/Setup.exe

    wine ${config.xdg.userDirs.documents}/Private/Apps/Windows/RTP100/Setup.exe
    wine ${config.xdg.userDirs.documents}/Private/Apps/Windows/RTP100/RGSS-RTP Standard.exe
    wine ${config.xdg.userDirs.documents}/Private/Apps/Windows/RTP100/RPGVX_RTP/Setup.exe
    winetricks -q dxvk vkd3d corefonts cjkfonts
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
    podman image pull -y registry.fedoraproject.org/fedora-toolbox:39
    podman image pull -y registry.opensuse.org/opensuse/tumbleweed:latest

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

    env SHELL=/bin/bash distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:latest --name ubuntu-latest --home ${config.xdg.userDirs.documents}/containers/ubuntu-latest
    distrobox enter ubuntu-latest -- sudo apt upgrade -y

  '';
};

home.file."setup-distrobox-fedora" = {
  enable = true;
  target = ".local/bin/setup-distrobox-fedora";
  executable = true;
  text = ''
    #! /bin/bash

    env SHELL=/bin/zsh distrobox create --image registry.fedoraproject.org/fedora-toolbox:39 --name fedora --home ${config.xdg.userDirs.documents}/containers/fedora
    distrobox enter fedora -- sudo dnf install -y dnf5 https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  '';
};

home.file."setup-distrobox-arch" = {
  enable = true;
  target = ".local/bin/setup-distrobox-arch";
  executable = true;
  text = ''
  #! /bin/bash

  env SHELL=/bin/fish distrobox create --image quay.io/toolbx-images/archlinux-toolbox:latest --name arch --home ${config.xdg.userDirs.documents}/containers/arch ; \
  distrobox enter arch -- sudo pacman -Su --noconfirm nano ; \
  distrobox enter arch -- sudo pacman-key --init ; \
  distrobox enter arch -- sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com ; \
  distrobox enter arch -- sudo pacman-key --lsign-key 3056513887B78AEB ; \
  distrobox enter arch -- sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' ; \
  distrobox enter arch -- sh -c "echo -e '[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' | sudo tee -a /etc/pacman.conf" ; \
  distrobox enter arch -- sh -c "echo -e '\nen_SG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8\nid_ID.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen"
  distrobox enter arch -- sudo pacman -Syu --noconfirm glibc base-devel paru git nano

  distrobox enter arch -- paru -Syyu --noconfirm lib32-pipewire wireplumber pipewire-jack lib32-pipewire-jack pipewire-pulse pipewire-alsa wireplumber lib32-alsa-plugins

  distrobox enter arch -- paru -Syyu --noconfirm --skipreview mesa lib32-sdl12-compat lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-mesa-layers libva-mesa-driver lib32-libva-mesa-driver mesa-utils vulkan-tools libva-utils lib32-mesa-utils giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama libxslt lib32-libxslt libva lib32-libva gtk3-classic lib32-gtk3 vulkan-icd-loader lib32-vulkan-icd-loader sdl2 lib32-sdl2 vkd3d lib32-vkd3d libgphoto2 ffmpeg gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-plugins-base lib32-gst-plugins-good lib32-gst-plugins-base gst-libav faudio lib32-faudio

  distrobox enter arch -- paru -Syyu --noconfirm xorg-server-xephyr xorg-xwayland wayland lib32-wayland wl-clipboard wl-clipboard-x11 qt5-wayland qt6-wayland libdbusmenu-qt5 libdbusmenu-qt6 libdbusmenu-gtk3 libdbusmenu-gtk2 appmenu-gtk-module kio qt6-base btrfs-progs udisks2-btrfs

  distrobox enter arch -- paru -Syyu --noconfirm zsh fish htop minizip eza bat aria2 sqlitebrowser xdg-desktop-portal-kde plasma-browser-integration ttf-meslo-nerd-font-powerlevel10k ttf-ibm-plex ttf-ms-fonts plasma5-theme-monterey-git plasma5-themes-whitesur-git whitesur-icon-theme-git whitesur-cursor-theme-git whitesur-gtk-theme-git adwaita-icon-theme

  distrobox enter arch -- paru -Syyu --noconfirm thorium-browser-bin junction peazip-qt5 p7zip unrar unarchiver lzop lrzip arj mpv-discordrpc mpv-discord-git 4kvideodownloaderplus spotify-adblock-git qtscrcpy scrcpy masterpdfeditor-free exifcleaner-bin teams-for-linux onedrive-abraunegg onedrivegui onedriver anydesk-bin vlc-wayland-git firejail firetools libreoffice-fresh pstoedit coin-or-mp libpaper sane unixodbc tesseract-data-eng tesseract-data-ind tesseract-data-jpn tesseract-data-jpn_vert

  distrobox enter arch -- paru -Syyu --noconfirm steam steam-native-runtime protontricks-git gamescope-plus gamemode lib32-gamemode mangohud-git archisteamfarm-bin sgdboop-bin thcrap-steam-proton-wrapper-git discord discord-rpc-git obs-studio-amf wine-tkg-staging-fsync-git winetricks-git wine-nine wineasio wine-ge-custom-opt

  git clone https://aur.archlinux.org/gazou-git.git /tmp/gazou-git
  cd /tmp/gazou-git
  sed -i 's/-DGUI=ON/-DGUI=OFF/' /tmp/gazou-git/PKGBUILD
  distrobox enter arch -- makepkg -si --noconfirm
  distrobox enter arch -- env HOME=/home/fenglengshun distrobox-export --bin /usr/sbin/gazou

  '';
};

home.file."setup-distrobox-opensuse-systemd" = {
  enable = true;
  target = ".local/bin/setup-distrobox-opensuse-systemd";
  executable = true;
  text = ''
  #! /bin/bash

  distrobox create --root --init --image registry.opensuse.org/opensuse/tumbleweed:latest --name opensuse-tumbleweed --home ${config.xdg.userDirs.documents}/containers/opensuse  --additional-packages "systemd"
  distrobox enter --root opensuse-tumbleweed -- sudo zypper install -y virt-manager libvirt qemu-hw-display-qxl qemu-hw-usb-redirect qemu-hw-usb-host qemu-hw-display-virtio-gpu qemu-hw-display-virtio-gpu-pci virtiofsd

  '';
};

home.file."setup-no-root-virt-manager" = {
  enable = true;
  target = ".local/bin/setup-no-root-virt-manager";
  executable = true;
  text = ''
    sudo usermod -a -G kvm ${config.home.username}
    sudo usermod -a -G libvirt ${config.home.username}
  '';
};

home.file."setup-adguardhome" = {
  enable = true;
  target = ".local/bin/setup-adguardhome";
  executable = true;
  text = ''
    #! /bin/bash
    sudo lsof -i :53
    sudo mkdir -p /etc/systemd/resolved.conf.d
    sudo touch /etc/systemd/resolved.conf.d/adguardhome.conf
    echo -e "[Resolve]\nDNS=127.0.0.1\nDNSStubListener=no" | sudo tee /etc/systemd/resolved.conf.d/adguardhome.conf
    sudo mv /etc/resolv.conf /etc/resolv.conf.backup
    sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
    sudo systemctl reload-or-restart systemd-resolved
    sudo lsof -i :53
    sudo ${config.home.homeDirectory}/.nix-profile/bin/adguardhome
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
    download_command="aria2c https://www.renpy.org/dl/$version/renpy-$version-sdk.tar.bz2 -d ${config.home.homeDirectory}/Downloads && tar -xjf ${config.home.homeDirectory}/Downloads/renpy-$version-sdk.tar.bz2 -C $renpy_dir"
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
