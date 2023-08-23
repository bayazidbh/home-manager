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
  nixpkgs.config.allowUnfreePredicate = _: true;

  #allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
  ];

  home.packages = with pkgs; [
    git gh github-desktop git-lfs cosign cachix subversion # build tools
    ibm-plex meslo-lgs-nf noto-fonts-emoji-blob-bin noto-fonts-cjk-sans noto-fonts-cjk-serif # fonts
    inxi neofetch grc highlight rmtrash libwebp unrar xdg-ninja # clipboard-jh # CLI utils
    erdtree delta grex fd # ripgrep-all bottom # rust CLIs
    duperemove rsync zsync resilio-sync  # file management
    # activitywatch rustdesk web-ui tools
    libdbusmenu libsForQt5.libdbusmenu # for global menu
    libsForQt5.breeze-qt5 libsForQt5.breeze-gtk libsForQt5.breeze-icons libsForQt5.applet-window-buttons # breeze dependencies
    sassc whitesur-gtk-theme whitesur-icon-theme gnome.adwaita-icon-theme # whitesur and adwaita dependencies
    fcitx5-gtk libsForQt5.fcitx5-qt # fcitx5 input method gui
    du-dust nix-du graphviz # disk usage management tools
    gallery-dl adl mangal mov-cli # CLI-based media downloader
    fsearch junction krename imagemagick # extra file management tools
    distrobox podman podman-compose # containers stuff
    # downonspot spotify-qt # media viewers
    # mesa amdvlk driversi686Linux.amdvlk # wine graphics dependencies
    # wineWowPackages.stagingFull dxvk wineWowPackages.fonts winetricks # wine packages
    # gst_all_1.gstreamer gst_all_1.gst-vaapi gst_all_1.gst-libav gst_all_1.gstreamermm gst_all_1.gst-plugins-rs # gstreamer
    # gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly # gstreamer-plugins
    gamemode protonup-ng ludusavi scanmem # gamescope other gaming tools
    # steamtinkerlaunch gawk yad # steamtinkerlaunch deps
  ];

  # enable fcitx5 as input method, with mozc for Japanese IME
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };

  # services.kdeconnect.enable = true; # Install and enable kdeconnect
  # services.kdeconnect.indicator = true; # Enable kdeconnect indicator
  # programs.gh.enable = true; # Install and enable GitHub CLI tool
  # programs.git-credential-oauth.enable = true; # enable Git authentication handler for OAuth.

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
}
