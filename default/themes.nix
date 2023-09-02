{ config, pkgs, ... }:
{
qt = {
    enable = true;
    platformTheme = "kde";
    style = {
    package = pkgs.whitesur-kde;
    name = WhiteSur-dark;
    };
};

gtk = {
    enable = true;

    font = {
      enable = true;
      package = pkgs.ibm-plex;
     #  name = "IBM Plex Sans";
      size = 9;
    };

    iconTheme = {
      enable = true;
      package = pkgs.whitesur-icon-theme;
      name = "WhiteSur-dark";
    };

    theme = {
      enable = true;
      package = pkgs.whitesur-gtk-theme;
      name = "WhiteSur-Dark-solid";
    };
}
