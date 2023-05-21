{ config, pkgs, ... }:

let

  #import other sources / branch

  #pkgsUnstable = import <nixpkgs-unstable> {};
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
  # aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");

  #chaotic-nix = import (builtins.fetchGit {
  #  url = "https://github.com/chaotic-cx/nyx";
  #  ref = "nyxpkgs-unstable";
  #});

  #revpkgs = import (builtins.fetchGit {
  #  url = "https://github.com/NixOS/nixpkgs/";
  #  ref = "refs/heads/nixos-unstable";
  #  rev = "c3f2eb7dba0ba89c4cd33ae4d8b2d92ea5baa109";
  #}) {};

in

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "fenglengshun";
  home.homeDirectory = "/home/fenglengshun";
  xdg.enable = true;
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.sessionVariables = {
    #XDG_DATA_HOME="$HOME/.local/share";
    #XDG_CONFIG_HOME="$HOME/.config";
    #XDG_STATE_HOME="$HOME/fenglengshun/.local/state";
    #XDG_CACHE_HOME="$HOME/.cache";
    #DOCKER_CONFIG="$HOME/.config/docker";
    CARGO_HOME="$HOME/.local/share/cargo";
    NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc";
    GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc";
    LESSHISTFILE="$HOME/.local/state/less/history";
    WINEPREFIX="$HOME/.local/share/wine";
    GTK_THEME="WhiteSur-Dark-solid";
    GTK_THEME_VARIANT="dark";
    };

  home.shellAliases = {

    # Environment shortcuts

    my_alias="sed -n '/home.shellAliases = {/,/}/ { //!p }' ~/.config/home-manager/home.nix | highlight --syntax=ini --out-format=ansi";
    update_desktop_files ="update-desktop-database ~/.local/share/applications ~/.nix-profile/share/applications /usr/local/share/applications /usr/share/applications -v " ;

    force-x11="env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11";
    force-portal="env GDK_DEBUG=portals GTK_USE_PORTAL=1";

    ip-addr-show="ip addr show";
    ISO-today="echo '%{Date:yyyyMMdd}_%{Time:hhmmss}\ndate \"+%a %Y-%m-%d %H:%M:%S\"' ; date +'%a %Y-%m-%d %H:%M:%S'";
    kill_user="pkill -KILL -u $USER";

    # General file operation shortcuts

    batch-zip-subfolders = "echo 'for i in */; do zip -9 -r \"\${i%/}.zip\" \"\$i\" & done; wait'";
    batch-cbz-subfolders = "echo 'for i in */; do zip -9 -r \"\${i%/}.cbz\" \"\$i\" & done; wait'";
    unzip_jp="echo 'unzip -O SHIFT-JIS file.zip\nunzip -O CP936 file.zip'";

    convert_to_animated_image = "echo 'ffmpeg -i video_file -loop 0 output.gif\nffmpeg -i video_file -loop 0 output.webp'";
    append_images="echo 'appends the images vertically\nconvert -append in-*.jpg out.jpg\nappends the images horizontally\nconvert in-1.jpg in-5.jpg in-N.jpg +append out.jpg'";
    convert_to_pdf="echo 'soffice --headless --norestore --convert-to pdf --outdir {OUT_DIR} {FILE}\nlibreoffice --headless --convert-to pdf *.xlsx\nflatpak run org.libreoffice.LibreOffice --headless --convert-to pdf *.docx'";

    # Nix Package Manager shortcuts

    home_manager_update="nix-channel --update && home-manager switch -b bak";
    clean-nix="nix-env --delete-generations old ; nix-store --gc ; nix-collect-garbage -d";
    du-nix="nix-du -s=500MB | dot -Tpng > ~/Downloads/nix-store.png";

    pull-home-manager-nix="cp -rpfv $HOME/Documents/Private/Linux/nixos/home.nix $HOME/.config/home-manager/";
    push-home-manager-nix="cp -rpfv $HOME/.config/home-manager/home.nix $HOME/Documents/Private/Linux/nixos/ ; cd $HOME/.config/home-manager";
    delta-home-manager-nix="delta $HOME/.config/home-manager/home.nix $HOME/Documents/Private/Linux/nixos/home.nix";
    clean-home-manager-nix="rmtrash -rfv $HOME/.config/home-manager/home.nix~* ; exa -al $HOME/.config/home-manager/";

    # Conty Shortcuts https://github.com/Kron4ek/Conty

    conty="HOME_DIR=$HOME/Documents/container/conty conty.sh --bind $HOME/.steam $HOME/.steam --bind $HOME/.local/share/Steam $HOME/.local/share/Steam --bind $HOME/Games $HOME/Games --bind $HOME/.local/share $HOME/.local/share --bind $HOME/.config $HOME/.config --bind $HOME/.local/state $HOME/.local/state --bind $HOME/.cache $HOME/.cache --bind $HOME/Storage $HOME/Storage --bind $HOME/Documents $HOME/Documents --bind $HOME/Downloads $HOME/Downloads";
    conty-export="HOME_DIR=$HOME/Documents/container/conty conty.sh -d --bind $HOME/.steam $HOME/.steam --bind $HOME/.local/share/Steam $HOME/.local/share/Steam --bind $HOME/Games $HOME/Games --bind $HOME/.local/share $HOME/.local/share --bind $HOME/.config $HOME/.config --bind $HOME/.local/state $HOME/.local/state --bind $HOME/.cache $HOME/.cache --bind $HOME/Storage $HOME/Storage --bind $HOME/Documents $HOME/Documents --bind $HOME/Downloads $HOME/Downloads";
    contywine="HOME_DIR=$HOME/Documents/container/conty WINEPREFIX=$HOME/.local/share/wineconty conty.sh --bind $HOME/.steam $HOME/.steam --bind $HOME/.local/share/Steam $HOME/.local/share/Steam --bind $HOME/Games $HOME/Games --bind $HOME/.local/share $HOME/.local/share --bind $HOME/.config $HOME/.config --bind $HOME/.local/state $HOME/.local/state --bind $HOME/.cache $HOME/.cache --bind $HOME/Storage $HOME/Storage --bind $HOME/Documents $HOME/Documents --bind $HOME/Downloads $HOME/Downloads wine";
    contywinejp="HOME_DIR=$HOME/Documents/container/conty LC_ALL=ja_JP.UTF-8 TZ=Asia/Tokyo WINEPREFIX=$HOME/Games/Unlocked/_winejp/ WINEARCH=win32 conty.sh  --bind $HOME/.steam $HOME/.steam --bind $HOME/.local/share/Steam $HOME/.local/share/Steam --bind $HOME/Games $HOME/Games --bind $HOME/.local/share $HOME/.local/share --bind $HOME/.config $HOME/.config --bind $HOME/.local/state $HOME/.local/state --bind $HOME/.cache $HOME/.cache --bind $HOME/Storage $HOME/Storage --bind $HOME/Documents $HOME/Documents --bind $HOME/Downloads $HOME/Downloads wine";

    # Conty Management
    pull-conty="cp -rpfv $HOME/Documents/Private/Linux/conty/conty.sh $HOME/.local/bin/";
    push-conty="cp -rpfv $HOME/.local/bin/conty.sh $HOME/Documents/Private/Linux/conty/";
    list-conty="ls -alh $HOME/.local/bin/conty.* $HOME/Documents/Private/Linux/conty/conty.* ; erd $HOME/Documents/Private/.sync/Archive/Linux/conty";
    clean-conty="rmtrash -rfv $HOME/.local/bin/conty.sh.old* ; rmtrash -rfv $HOME/Documents/Private/.sync/Archive/Linux/conty/*";

    # Games
    steam-silent="steam -nochatui -nofriendsui -silent";
    gamescope_run="gamescope -w 1477 -h 831 -W 1920 -H 1080 -r 60 -o 30 -f --fsr-upscaling --fsr-sharpness 10 --steam --adaptive-sync --";
    winejp="LC_ALL=ja_JP.UTF-8 TZ=Asia/Tokyo WINEPREFIX=$HOME/Games/Unlocked/_winejp/ WINEARCH=win32 wine";
    nw="env LD_PRELOAD=$HOME/.local/bin/nwjs/libffmpeg.so $HOME/.local/bin/nwjs/nw";
    nw72="env LD_PRELOAD=$HOME/.local/bin/nwjs-v0.72.0-linux-x64/libffmpeg.so $HOME/.local/bin/nwjs-v0.72.0-linux-x64/nw";
    nw76="env LD_PRELOAD=$HOME/.local/bin/nwjs-v0.76.1-linux-x64/libffmpeg.so $HOME/.local/bin/nwjs-v0.76.1-linux-x64/nw";

    pull-betterdiscord="mkdir -p $HOME/.config/BetterDiscord && cp -rpfv $HOME/Documents/Private/Apps/Backups/BetterDiscord $HOME/.config/";
    push-betterdiscord="mkdir -p $HOME/Documents/Private/Apps/Backups/BetterDiscord/ && cp -rpfv $HOME/.config/BetterDiscord/* $HOME/Documents/Private/Apps/Backups/BetterDiscord/";

    ## declarative flatpak stuff

    # list only apps (no runtime) from flathub
    flathub-list="flatpak list --user --app --columns=application,origin | grep flathub | awk '{print \$1}'";

    # Compares the lists of installed and uninstalled flatpak apps, and highlights the differences
    list-flatpak="mkdir -p $HOME/.var/log/flatpak ; echo '\nFlatpak Runtimes:\n' ; bat -P $HOME/.config/home-manager/flatpak-runtimes.txt ; echo '\nFlatpak Apps Future:\n' ; bat -P $HOME/.config/home-manager/flatpak-apps.txt ; echo '\nFlatpak Apps Past:\n' ; bat -P $HOME/.var/log/flatpak/flatpak-apps.txt ; echo '\nFlatpak Apps Present:\n' ; bat -P <(flathub-list) ; echo '\nNot yet installed:\n' ; grep -vxFf <(flathub-list) $HOME/.config/home-manager/flatpak-apps.txt ; echo '\nNot yet removed:\n' ; grep -vxFf $HOME/.config/home-manager/flatpak-apps.txt <(flathub-list)";

    # Displays the current synced and installed flatpak apps, highlights the apps being added and removed, moves the log file to a new location with a timestamp, and updates the flatpak app and runtime lists
    push-flatpak="mkdir -p $HOME/.var/log/flatpak ; echo '\nCurrent Synced:\n' ; bat -P $HOME/.config/home-manager/flatpak-apps.txt ; echo '\nCurrent Installed:\n' ; bat -P <(flathub-list) ; echo '\nAdding:\n' ; grep -vxFf $HOME/.config/home-manager/flatpak-apps.txt <(flathub-list) ; echo '\nRemoving:\n' ; grep -vxFf <(flathub-list) $HOME/.config/home-manager/flatpak-apps.txt ; mv $HOME/.var/log/flatpak/flatpak-apps.txt $HOME/.var/log/flatpak/flatpak-apps-$(date '+%Y%m%d_%H%M%S').txt && flathub-list > $HOME/.config/home-manager/flatpak-apps.txt ; flathub-list > $HOME/.var/log/flatpak/flatpak-apps.txt ; echo 'runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08\ncom.valvesoftware.Steam.Utility.gamescope' > $HOME/.config/home-manager/flatpak-runtimes.txt";

    # Moves the existing log file to a new location, updates the log file with the current list of flatpak apps. Installs the apps that are present in the source file but not in the log file, and uninstalls the apps that are present in the log file but not in the source file. Then make sure everything else is updated.
    pull-flatpak="mkdir -p $HOME/.var/log/flatpak ; mv $HOME/.var/log/flatpak/flatpak-apps.txt $HOME/.local/share/flatpak/flatpak-apps-$(date '+%Y%m%d_%H%M%S').txt && flathub-list > $HOME/.var/log/flatpak/flatpak-apps.txt ; flatpak install --user -y $(grep -vxFf $HOME/.var/log/flatpak/flatpak-apps.txt $HOME/.config/home-manager/flatpak-apps.txt) ; flatpak install --user -y $(cat $HOME/.config/home-manager/flatpak-runtimes.txt) ; flatpak uninstall --user -y $(grep -vxFf $HOME/.config/home-manager/flatpak-apps.txt $HOME/.var/log/flatpak/flatpak-apps.txt) ; upgrade-flatpak";

    # Other flatpak management
    edit-flatpak="nano $HOME/.config/home-manager/flatpak-apps.txt ; list-flatpak";
    upgrade-flatpak="mkdir -p $HOME/.var/log/flatpak ; flatpak upgrade -y >> $HOME/.var/log/flatpak/flatpak-upgrade-$(date '+%Y-%m-%d').log";
    list-overrides-flatpak="bat -P --style=header,numbers,snip ~/.local/share/flatpak/overrides/* ~/Documents/Private/Linux/flatpak/overrides/*";
    push-overrides-flatpak="cp -rfpv ~/.local/share/flatpak/overrides ~/Documents/Private/Linux/flatpak ";
    pull-overrides-flatpak="cp -rfpv ~/Documents/Private/Linux/flatpak/overrides ~/.local/share/flatpak";
    };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";
  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Update Nix channels, when running home-manager switch, checks per-week
  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "weekly";
  };

  # Ensure that the following packages are installed
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    git gh cachix
    # glibcLocalesUtf8
    gawk yad # toybox unzip xdotool xorg.xprop xorg.xrandr # steamtinkerlaunch deps
    ibm-plex meslo-lgs-nf corefonts noto-fonts-emoji-blob-bin noto-fonts-cjk-sans noto-fonts-cjk-serif # fonts
    # wayland wayland-utils wayland-protocols xwayland libsForQt5.plasma-wayland-protocols libsForQt5.qt5.qtwayland libsForQt5.kwayland-integration libsForQt5.kwayland
    inxi neofetch grc highlight rmtrash squashfs-tools-ng dwarfs libwebp # clipboard-jh # CLI utils
    erdtree ripgrep-all delta grex bandwhich bottom fd # rust CLIs
    rsync grsync zsync resilio-sync  # file management
    libdbusmenu libsForQt5.libdbusmenu # for global menu
    libsForQt5.breeze-qt5 libsForQt5.breeze-gtk libsForQt5.breeze-icons # libsForQt5.applet-window-buttons # breeze dependencies
    sassc whitesur-gtk-theme whitesur-icon-theme gnome.adwaita-icon-theme # whitesur and adwaita dependencies
    fcitx5-gtk libsForQt5.fcitx5-qt # fcitx5 input method gui
    du-dust qdirstat czkawka metadata-cleaner nix-du graphviz # disk usage management tools
    ani-cli manga-cli mov-cli # CLI-based media downloader
    junction krename fsearch # extra file management tools
    distrobox podman podman-compose podman-desktop # containers stuff
    discord discord-rpc betterdiscordctl # discord-screenaudio # discord and related
    mpv-unwrapped gimp-with-plugins mcomix # downonspot spotify-qt # media viewers
    mesa amdvlk driversi686Linux.amdvlk # wine graphics dependencies
    # gamescope libdisplay-info libliftoff jsoncpp openvr seatd wlroots libdrm vulkan-extension-layer vulkan-loader vulkan-headers wineWowPackages.stagingFull wineWowPackages.waylandFull
    nix-gaming.packages.${pkgs.hostPlatform.system}.wine-tkg dxvk wineWowPackages.fonts winetricks # wine packages
    gamemode protontricks steamtinkerlaunch protonup-qt protonup-ng steam-rom-manager ludusavi # scanmem heroic-unwrapped # other gaming tools
    # aagl-gtk-on-nix.an-anime-game-launcher aagl-gtk-on-nix.the-honkers-railway-launcher aagl-gtk-on-nix.honkers-launcher
  ];

  # services.kdeconnect.enable = true; # Install and enable kdeconnect
  # services.kdeconnect.indicator = true; # Enable kdeconnect indicator

  # Install and enable gpg package and change homedir to $HOME/.local/share/gnupg
  #programs.gpg = {
  #  enable = true;
  #  homedir = "${config.xdg.dataHome}/gnupg";
  #};

  # Install and enable ssh with forwardAgent enabled for password entry
  #programs.ssh = {
  #  enable = true;
  #  forwardAgent = true;
  #};

  # Install and enable git package and settings management
  #programs.git = {
  #  enable = true;
  #  userName  = "";
  #  userEmail = "";
  #  extraConfig = {
  #    init = {
  #      defaultBranch = "main";
  #    };
  #    pull = {
  #      rebase = true;
  #    };
  #    rebase = {
  #      autostash = true;
  #    };
  #  };
  #};

  #programs.gh.enable = true; # Install and enable GitHub CLI tool

  # enable fcitx5 as input method, with mozc for Japanese IME
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };

  # allows home-manager to manager bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      export PS1="\\[\\033[01;32m\\]\\u@\\h:\\w\\[\\033[00m\\]\\$ "
      '';
    historyFile = "${config.xdg.configHome}/bash_history";
  };
  # Install zsh, and allows home-manager to manage zsh configs, with plugins, and oh-my-zsh management
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autocd = true;
    history =  {
      path = "${config.xdg.configHome}/zsh/zsh_history";
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    # source p10k theme at ZSH_CUSTOM in XDG_DATA_HOME
    initExtra = "[[ ! -f ${config.xdg.configHome}/zsh/p10k.zsh ]] || source ${config.xdg.configHome}/zsh/p10k.zsh";
    oh-my-zsh = {
      enable = true;
      custom = "${config.xdg.configHome}/zsh/custom/plugins";
      plugins = [ "git" "zsh-autosuggestions" "zsh-history-substring-search" "zsh-syntax-highlighting" ];
      theme = "powerlevel10k/powerlevel10k";
    };
  };
  # Install fish and allows home-manager to manage fish configs
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set sponge_purge_only_on_exit true
      alias batch-zip-subfolders 'for i in */; zip -9 -r "$i".zip "$i"; end; wait'
      alias batch-cbz-subfolders 'for i in */; zip -9 -r "$i".cbz "$i"; end; wait'
    ''; # Disable greeting, sponge only purge on exit
    plugins = [
     { name = "tide"; src = pkgs.fishPlugins.tide.src; } # p10k-like theme for fish
     { name = "grc"; src = pkgs.fishPlugins.grc.src; } # grc for colorized command output
     { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; } # PatrickF1 fzf key bindings
     { name = "sponge"; src = pkgs.fishPlugins.sponge.src; } # clean fish history from typos automatically
     { name = "z"; src = pkgs.fishPlugins.z.src; } # Pure-fish z directory jumping
     ];
    };

  programs.aria2.enable = true; # Install and enable aria2
  programs.bat.enable = true; # Install and enable bat, a rust-replacement for cat
  programs.exa = {
    enable = true; # Install and enable exa, a rust-replacement for ls
    enableAliases = true; # Enable recommended exa aliases (ls, ll…)
    icons = true; # Display icons next to file names in exa (--icons argument).
  };
  programs.fzf.enable = true; # Install and enable fzf - a command-line fuzzy finder.
  programs.hstr.enable = true; # Install and enable hstr Bash And Zsh shell history suggest box
  programs.mangohud.enable = true; # Install and enable mangohud
  services.mpd-discord-rpc.enable = true; # Install service for sharing current music info to discord

  # Rebuild .desktop file database for app launcher menus
  xdg.mime.enable = true;

  # Add cachix access to ~/.config/nix/nix.conf
  home.file."nix.conf" = {
    target = ".config/nix/nix.conf";
    text = ''
      substituters = https://cache.nixos.org https://nix-gaming.cachix.org https://chaotic-nyx.cachix.org https://ezkea.cachix.org
      trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4= nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=
      '';
  };

  # home.activation = {
  #   linkDesktopApplications = {
  #     after = [ "writeBoundary" "createXdgUserDirectories" ];
  #     before = [ ];
  #     data = "/usr/bin/sudo /usr/bin/update-desktop-database";
  #     };
  # };

  #home.activation = {
  # do an upgrade of installed flatpak apps
  #  flatpakUpgrade = {
  #    after = [ "writeBoundary" "createXdgUserDirectories" ];
  #    before = [ "flatpakPkgs" ];
  #    data = "/usr/bin/flatpak upgrade -y >> $HOME/.var/log/flatpak-upgrade-$(date '+%Y-%m-%d').log";
  #    };
    # recreate flatpak overrides
    #flatpakOverrideFolders = {
  #    after = [ "writeBoundary" "createXdgUserDirectories" ];
  #    before = [ ];
  #    data = "/usr/bin/mkdir -m 666 -p $HOME/.local/share/flatpak/overrides && /usr/bin/echo -e '[Context]\ndevices=dri\nfeatures=bluetooth\nfilesystems=xdg-documents;xdg-download' > $HOME/.local/share/flatpak/overrides/com.github.Eloston.UngoogledChromium && /usr/bin/echo -e '[Context]\nsockets=fallback-x11\ndevices=dri\nfeatures=bluetooth\nfilesystems=xdg-documents;home' > $HOME/.local/share/flatpak/overrides/com.usebottles.bottles && /usr/bin/echo -e '[Context]\nfilesystems=xdg-data/fonts:ro' > $HOME/.local/share/flatpak/overrides/com.wps.Office && /usr/bin/echo -e '[Context]\nfilesystems=xdg-config/MangoHud:ro;$HOME/Storage:rw;$HOME/.themes:ro;$HOME/.icons:ro;xdg-data/icons:ro;xdg-config/gtk-4.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtkrc:ro\n\n[Environment]\nGTK_THEME=WhiteSur-Dark-solid\nGTK_THEME_VARIANT=dark\n\n[Session Bus Policy]\norg.kde.kconfig.notify=talk\norg.kde.StatusNotifierWatcher=talk\norg.kde.KGlobalSettings=talk\ncom.canonical.AppMenu.Registrar=talk\ncom.feralinteractive.GameMode=talk' > $HOME/.local/share/flatpak/overrides/global && /usr/bin/echo -e '[Context]\nfilesystems=xdg-download;xdg-videos' > $HOME/.local/share/flatpak/overrides/io.github.aandrew_me.ytdn && /usr/bin/echo -e '[Context]\nfilesystems=xdg-documents' > $HOME/.local/share/flatpak/overrides/org.ferdium.Ferdium && /usr/bin/chmod 666 $HOME/.local/share/flatpak/overrides/*";
  #    };
  #};
}
