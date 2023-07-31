{ config, ... }:
{
  home.packages = with pkgs; [
    fastfetch
  ];
}
