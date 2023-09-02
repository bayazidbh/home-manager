{ pkgs, ... }:
{
  nix.package = pkgs.nixVersions.unstable;
  home.packages = with pkgs; [
    fastfetch # gamescope_git
  ];
}
