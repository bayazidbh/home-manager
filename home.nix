{ config, pkgs, ... }:

let

  #import other sources / branch

  #pkgsUnstable = import <nixpkgs-unstable> {};
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
  nixgl = import <nixgl> {};
  # aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");

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
    CARGO_HOME="$HOME/.local/share/cargo";
    NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc";
    GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc";
    LESSHISTFILE="$HOME/.local/state/less/history";
    WINEPREFIX="$HOME/.local/share/wine";
    GTK_THEME="WhiteSur-Dark-solid";
    GTK_THEME_VARIANT="dark";
    };

  # imports = [
  #   aagl-gtk-on-nix.module
  # ];

  home.shellAliases = {

    # Environment shortcuts

    my_alias="bat -r 46:122 ~/.config/home-manager/home.nix";
    update_desktop_files ="update-desktop-database ~/.local/share/applications ~/.nix-profile/share/applications /usr/local/share/applications /usr/share/applications -v " ;

    force-x11="QT_QPA_PLATFORM=xcb GDK_BACKEND=x11";
    force-portal="GDK_DEBUG=portals GTK_USE_PORTAL=1";

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

    # Conty Shortcuts https://github.com/Kron4ek/Conty

    conty="HOME_DIR=$HOME/Documents/container/conty $HOME/.local/bin/conty.sh --bind $HOME/Games $HOME/Games --bind $HOME/Storage $HOME/Storage --bind $HOME/Documents $HOME/Documents --bind $HOME/Downloads $HOME/Downloads";
    conty-unrestrict="HOME_DIR=$HOME/Documents/container/conty $HOME/.local/bin/conty.sh --bind $HOME/.steam $HOME/.steam --bind $HOME/.local/share/Steam $HOME/.local/share/Steam --bind $HOME/Games $HOME/Games --bind $HOME/.local/share $HOME/.local/share --bind $HOME/.config $HOME/.config --bind $HOME/.local/state $HOME/.local/state --bind $HOME/.cache $HOME/.cache --bind $HOME/Storage $HOME/Storage --bind $HOME/Documents $HOME/Documents --bind $HOME/Downloads $HOME/Downloads";

    conty-export="HOME_DIR=$HOME/Documents/container/conty $HOME/.local/bin/conty.sh --bind $HOME/Games $HOME/Games --bind $HOME/Storage $HOME/Storage --bind $HOME/Documents $HOME/Documents --bind $HOME/Downloads $HOME/Downloads";
    conty-export-unrestrict="HOME_DIR=$HOME/Documents/container/conty $HOME/.local/bin/conty.sh -d --bind $HOME/.steam $HOME/.steam --bind $HOME/.local/share/Steam $HOME/.local/share/Steam --bind $HOME/Games $HOME/Games --bind $HOME/.local/share $HOME/.local/share --bind $HOME/.config $HOME/.config --bind $HOME/.local/state $HOME/.local/state --bind $HOME/.cache $HOME/.cache --bind $HOME/Storage $HOME/Storage --bind $HOME/Documents $HOME/Documents --bind $HOME/Downloads $HOME/Downloads";

    contywine="WINEPREFIX=$HOME/.local/share/wineconty $HOME/.local/bin/conty.sh wine ./Game.exe";
    contywinejp="LC_ALL=ja_JP.UTF-8 TZ=Asia/Tokyo WINEPREFIX=$HOME/Games/Unlocked/_winejp/ WINEARCH=win32 $HOME/.local/bin/conty.sh wine";
    contygamescope="WINEPREFIX=$HOME/.local/share/wineconty $HOME/.local/bin/conty.sh gamescope -w 1477 -h 831 -W 1920 -H 1080 -r 60 -o 30 -f --fsr-upscaling --fsr-sharpness 10 -- wine";

    # Games
    steam-silent="steam -nochatui -nofriendsui -silent";
    gamescope_run="gamescope -w 1477 -h 831 -W 1920 -H 1080 -r 60 -o 30 -f --fsr-upscaling --fsr-sharpness 10 --steam --adaptive-sync --";
    winejp="LC_ALL=ja_JP.UTF-8 TZ=Asia/Tokyo WINEPREFIX=$HOME/Games/Unlocked/_winejp/ WINEARCH=win32 wine";
    nw="LD_PRELOAD=$HOME/.local/bin/nwjs/libffmpeg.so $HOME/.local/bin/nwjs/nw";
    nw72="LD_PRELOAD=$HOME/.local/bin/nwjs-v0.72.0-linux-x64/libffmpeg.so $HOME/.local/bin/nwjs-v0.72.0-linux-x64/nw";

    pull-betterdiscord="mkdir -p $HOME/.config/BetterDiscord && cp -rpfv $HOME/Documents/Private/Apps/Backups/BetterDiscord $HOME/.config/";
    push-betterdiscord="mkdir -p $HOME/Documents/Private/Apps/Backups/BetterDiscord/ && cp -rpfv $HOME/.config/BetterDiscord/* $HOME/Documents/Private/Apps/Backups/BetterDiscord/";

    ## declarative flatpak stuff

    # list only apps (no runtime) from flathub
    flathub-list="flatpak list --user --app --columns=application,origin | grep flathub | awk '{print \$1}'";

    # Compares the lists of installed and uninstalled flatpak apps, and highlights the differences
    list-flatpak="mkdir -p $HOME/.var/log/flatpak ; echo '\nFlatpak Runtimes:\n' ; bat -P $HOME/.config/home-manager/flatpak/runtimes.txt ; echo '\nFlatpak Apps Future:\n' ; bat -P $HOME/.config/home-manager/flatpak/flathub-apps.txt ; echo '\nFlatpak Apps Past:\n' ; bat -P $HOME/.var/log/flatpak/flathub-apps.txt ; echo '\nFlatpak Apps Present:\n' ; bat -P <(flathub-list) ; echo '\nNot yet installed:\n' ; grep -vxFf <(flathub-list) $HOME/.config/home-manager/flatpak/flathub-apps.txt ; echo '\nNot yet removed:\n' ; grep -vxFf $HOME/.config/home-manager/flatpak/flathub-apps.txt <(flathub-list)";

    # Displays the current synced and installed flatpak apps, highlights the apps being added and removed, moves the log file to a new location with a timestamp, and updates the flatpak app and runtime lists. Then restore the flatpak overrides.
    push-flatpak="mkdir -p $HOME/.var/log/flatpak ; echo '\nCurrent Synced:\n' ; bat -P $HOME/.config/home-manager/flatpak/flathub-apps.txt ; echo '\nCurrent Installed:\n' ; bat -P <(flathub-list) ; echo '\nAdding:\n' ; grep -vxFf $HOME/.config/home-manager/flatpak/flathub-apps.txt <(flathub-list) ; echo '\nRemoving:\n' ; grep -vxFf <(flathub-list) $HOME/.config/home-manager/flatpak/flathub-apps.txt ; mv $HOME/.var/log/flatpak/flathub-apps.txt $HOME/.var/log/flatpak/flatpak-apps-$(date '+%Y%m%d_%H%M%S').txt && flathub-list > $HOME/.config/home-manager/flatpak/flathub-apps.txt ; flathub-list > $HOME/.var/log/flatpak/flathub-apps.txt ; cp -rfpv ~/.local/share/flatpak/overrides/* ~/.config/home-manager/flatpak/overrides";

    # Moves the existing log file to a new location, updates the log file with the current list of flatpak apps. Installs the apps that are present in the source file but not in the log file, and uninstalls the apps that are present in the log file but not in the source file. Then make sure everything else is updated and flatpak overrides are backed up.
    pull-flatpak="mkdir -p $HOME/.var/log/flatpak ; mv $HOME/.var/log/flatpak/flathub-apps.txt $HOME/.var/log/flatpak/flathub-apps-$(date '+%Y%m%d_%H%M%S').txt ; flathub-list > $HOME/.var/log/flatpak/flathub-apps.txt ; flatpak install --user --app --or-update --noninteractive $(grep -vxFf $HOME/.var/log/flatpak/flathub-apps.txt $HOME/.config/home-manager/flatpak/flathub-apps.txt) ; flatpak uninstall --user --app --noninteractive $(grep -vxFf $HOME/.config/home-manager/flatpak/flathub-apps.txt $HOME/.var/log/flatpak/flathub-apps.txt) ; flatpak install --user --runtime --or-update --noninteractive $(cat $HOME/.config/home-manager/flatpak/runtimes.txt) ; ~/.config/home-manager/flatpak/launcher.moe ; cp -rfpv ~/.config/home-manager/flatpak/overrides/* ~/.local/share/flatpak/overrides";

    # Other flatpak management
    edit-flatpak="nano $HOME/.config/home-manager/flatpak/flathub-apps.txt ; list-flatpak";
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

  #allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u" # github-desktop
  ];

  home.packages = with pkgs; [
    git gh git-lfs github-desktop cachix # build tools
    ibm-plex meslo-lgs-nf noto-fonts-emoji-blob-bin noto-fonts-cjk-sans noto-fonts-cjk-serif # fonts
    inxi neofetch grc highlight rmtrash libwebp # clipboard-jh # CLI utils
    erdtree ripgrep-all delta grex fd # bottom # rust CLIs
    rsync zsync resilio-sync  # file management
    zerotierone activitywatch # web-ui tools
    libdbusmenu libsForQt5.libdbusmenu # for global menu
    # libsForQt5.breeze-qt5 libsForQt5.breeze-gtk libsForQt5.breeze-icons libsForQt5.applet-window-buttons # breeze dependencies
    sassc # whitesur-gtk-theme whitesur-icon-theme gnome.adwaita-icon-theme # whitesur and adwaita dependencies
    fcitx5-gtk libsForQt5.fcitx5-qt # fcitx5 input method gui
    du-dust nix-du graphviz # disk usage management tools
    ani-cli manga-cli mov-cli # CLI-based media downloader
    fsearch junction krename imagemagick # extra file management tools
    distrobox podman podman-compose podman-desktop # containers stuff
    # downonspot spotify-qt # media viewers
    mesa amdvlk driversi686Linux.amdvlk nixgl.nixGLIntel nixgl.nixVulkanIntel # wine graphics dependencies
    nix-gaming.packages.${pkgs.hostPlatform.system}.wine-tkg dxvk wineWowPackages.fonts winetricks # wine packages
    gamemode steamtinkerlaunch protonup-ng ludusavi # gamescope scanmem # other gaming tools
    gawk yad # steamtinkerlaunch deps
    # aagl-gtk-on-nix.an-anime-game-launcher aagl-gtk-on-nix.the-honkers-railway-launcher aagl-gtk-on-nix.honkers-launcher
  ];

  # services.kdeconnect.enable = true; # Install and enable kdeconnect
  # services.kdeconnect.indicator = true; # Enable kdeconnect indicator

  #programs.gh.enable = true; # Install and enable GitHub CLI tool
  #programs.git-credential-oauth.enable = true; # enable Git authentication handler for OAuth.

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
  programs.ripgrep.enable = true; # Install and enable ripgrep - rust rebuild of grep

  programs.boxxy = {
    enable = true;
  }; # Boxes in badly behaving applications https://github.com/queer/boxxy

  # programs.anime-game-launcher.enable = true;
  # programs.honkers-railway-launcher.enable = true;
  # programs.honkers-launcher.enable = true;

  # Rebuild .desktop file database for app launcher menus
  xdg.mime.enable = true;

  # Add cachix access to ~/.config/nix/nix.conf
  # home.file."nix.conf" = {
  #   target = ".config/nix/nix.conf";
  #   text = ''
  #     substituters = https://cache.nixos.org https://nix-gaming.cachix.org https://chaotic-nyx.cachix.org https://ezkea.cachix.org
  #     trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4= nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=
  #     '';
  # };
}
