{ config, pkgs, ... }:
let

  #import other sources / branch

  # pkgsUnstable = import <nixpkgs-unstable> {};
  # nixpkgs = import (builtins.fetchTarball "https://nixos.org/channels/nixpkgs-unstable");
  # nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
  # nixgl = import <nixgl> {};
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
  nixpkgs.config.allowUnfreePredicate = _: true; # needed for flakes

  #allow insecure packages
  # nixpkgs.config.permittedInsecurePackages = [
  #   "electron-24.8.6"
  # ];

  home.packages = with pkgs; [
    gh github-desktop git-lfs cosign cachix # git subversion # build tools
    # qt6.qtwayland wl-clipboard wl-clipboard-x11 # libsForQt5.qt5.qtwayland for wayland copy-paste
    inxi grc highlight rmtrash libwebp unrar xdg-ninja # CLI utils
    erdtree delta grex fd bottom ripgrep-all # rust CLIs
    rsync grsync zsync resilio-sync # duperemove czkawka metadata-cleaner # file management
    # libdbusmenu libsForQt5.libdbusmenu libsForQt5.applet-window-buttons # for unity-ui on KDE
    # libsForQt5.breeze-qt5 libsForQt5.breeze-gtk libsForQt5.breeze-icons gnome.adwaita-icon-theme # breeze & adwaita dependencies
    whitesur-gtk-theme whitesur-icon-theme # whitesur-kde sassc # whitesur theme
    du-dust nix-du graphviz # disk usage management tools
    adl gallery-dl mangal mov-cli # CLI-based media downloader
    protonup-ng # steam-rom-manager protontricks # steam tools
    # ludusavi scanmem gnome.zenity gamescope gamemode # other gaming tools
    mediawriter ventoy-full # image writer
    qdirstat fsearch junction imagemagick # transmission-qt # extra file management tools
    vesktop premid # discord
    # brave wavebox motrix # browsers
    # ibm-plex meslo-lgs-nf noto-fonts-emoji-blob-bin noto-fonts-cjk-sans noto-fonts-cjk-serif # fonts
    # libva1 libva-utils libvpx # codecs
    # gimp-with-plugins # media tools
    # adguardhome # network
    # fcitx5-gtk libsForQt5.fcitx5-qt # fcitx5 input method gui
    # bottles-unwrapped heroic-unwrapped # game runner
    # sqlitebrowser
    # rustdesk downonspot spotify-qt # media viewers
  ];

  # enable fcitx5 as input method, with mozc for Japanese IME
  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  # };

  # services.kdeconnect.enable = true; # Install and enable kdeconnect
  # services.kdeconnect.indicator = true; # Enable kdeconnect indicator

  programs.git-credential-oauth.enable = true; # enable Git authentication handler for OAuth.

  programs.aria2.enable = true; # Install and enable aria2
  programs.bat.enable = true; # Install and enable bat, a rust-replacement for cat
  programs.eza = {
    enable = true; # Install and enable exa, a rust-replacement for ls
    icons = true; # Display icons next to file names in exa (--icons argument).
  };
  programs.fzf.enable = true; # Install and enable fzf - a command-line fuzzy finder.
  programs.hstr.enable = true; # Install and enable hstr Bash And Zsh shell history suggest box
  # programs.mangohud.enable = true; # Install and enable mangohud
  services.mpd-discord-rpc.enable = true; # Install service for sharing current music info to discord
  programs.ripgrep.enable = true; # Install and enable ripgrep - rust rebuild of grep
  programs.boxxy = {
    enable = true;
  }; # Boxes in badly behaving applications https://github.com/queer/boxxy
  services.arrpc.enable = true; # arrpc for Vesktop's discord status
  # services.psd.enable = true; # Profile-sync-daemon for browser
  # xdg.portal = {
  #  enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.portal.enable
  #  config = {
  #    common = {
  #      default = [
  #        "kde"
  #      ];
  #    };
  #  };
  # };

home.activation = {
    linkDesktopApplications = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [ ];
      data = ''
        rm -rf ${config.home.homeDirectory}/.nix-desktop-files
        rm -rf ${config.home.homeDirectory}/.local/share/applications/home-manager
        rm -rf ${config.home.homeDirectory}/.icons/nix-icons
        mkdir -p ${config.home.homeDirectory}/.nix-desktop-files
        mkdir -p ${config.home.homeDirectory}/.icons
        ln -sf ${config.home.homeDirectory}/.nix-profile/share/icons ${config.home.homeDirectory}/.icons/nix-icons
        /usr/bin/desktop-file-install ${config.home.homeDirectory}/.nix-profile/share/applications/*.desktop --dir ${config.home.homeDirectory}/.local/share/applications/home-manager
        sed -i 's/Exec=/Exec=\/home\/${config.home.username}\/.nix-profile\/bin\//g' ${config.home.homeDirectory}/.local/share/applications/home-manager/*.desktop
        /usr/bin/update-desktop-database ${config.home.homeDirectory}/.local/share/applications
      '';
    };
  };

}
