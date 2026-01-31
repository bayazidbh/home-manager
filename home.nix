{ config, pkgs, ... }:

{
  # Home Manager settings
  programs.home-manager.enable = true;
  home.username = "fenglengshun";
  home.homeDirectory = "/home/fenglengshun";
  home.stateVersion = "25.11"; # DO NOT CHANGE
  services.home-manager = {
    autoUpgrade = {
      enable = true;
      useFlake = true;
      flakeDir = "${config.xdg.configHome}/home-manager";
      frequency = "*-*-* 00:20:00"; # daily 8PM
    };
    autoExpire = {
      enable = true;
      frequency = "*-*-* 00:23:00"; # daily 11PM
      timestamp = "-30 days";
      store = {
        cleanup = true;
        options = "--delete-older-than 30d";
      };
    };
  };


  # Set up for non-NixOS use
  targets.genericLinux = {
    enable = true;
    gpu.enable = true;
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true; # needed for flakes

  # Package lists
  home.packages = with pkgs; [
    dust nix-du graphviz cachix # nix tools
    gh github-desktop git-lfs # build tools
    grc highlight # text coloring
    firejail boxxy # sandboxing
    aria2 rsync zsync # file transfer tools
    chezmoi sqlitebrowser rmtrash unrar xdg-ninja chkcrontab # CLI utils
    erdtree delta grex fd bottom ripgrep-all # rust CLIs
    adl gallery-dl mangal mov-cli # CLI-based media downloader
    android-tools adbtuifm # android

    kdePackages.filelight kdePackages.kcharselect kdePackages.kcalc kdePackages.kcolorchooser
    kdePackages.kontrast kdePackages.arianna haruna krename

    fsearch grsync qdirstat czkawka peazip # file management
    firefox google-chrome microsoft-edge vivaldi vivaldi-ffmpeg-codecs # brave # browser
    masterpdfeditor4 normcap # wpsoffice # document editing
    protonvpn-gui proton-pass proton-authenticator # proton
    qbittorrent resilio-sync rquickshare # file transfer
    stremio vlc mcomix mangayomi koreader # multimedia
    distrobox gearlever boxbuddy # app management
    bottles # gaming

  ];

  # Allow insecure packages:
  nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ]; # for Stremio

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fenglengshun/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
