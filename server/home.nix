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
  xdg.enable = true;
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

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
  # Rebuild .desktop file database for app launcher menus
  xdg.mime.enable = true;

  # Ensure that the following packages are installed
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.packages = with pkgs; [
    git inxi neofetch grc highlight rmtrash # clipboard-jh # CLI utils
    erdtree ripgrep-all delta grex fd bottom # rust CLIs
    resilio-sync rsync zsync # file-management tools
    podman podman-compose
  ];

  programs.aria2.enable = true; # Install and enable aria2
  programs.bat.enable = true; # Install and enable bat, a rust-replacement for cat
  programs.eza = {
    enable = true; # Install and enable eza, a rust-replacement for ls
    enableAliases = true; # Enable recommended eza aliases (ls, ll…)
    icons = true; # Display icons next to file names in exa (--icons argument).
  };
  programs.fzf.enable = true; # Install and enable fzf - a command-line fuzzy finder.
  programs.hstr.enable = true; # Install and enable hstr Bash And Zsh shell history suggest box
  programs.ripgrep.enable = true; # Install and enable ripgrep - rust rebuild of grep
}
