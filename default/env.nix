{ config, pkgs, ... }:

{
xdg.enable = true;

xdg.userDirs = {
  enable = true;
  createDirectories = true;
  };

# Rebuild .desktop file database for app launcher menus
xdg.mime.enable = true;

home.sessionVariables = {
  XDG_BIN_HOME= "${config.home.homeDirectory}/.local/bin";
  CARGO_HOME="${config.xdg.dataHome}/cargo";
  NPM_CONFIG_USERCONFIG="${config.xdg.configHome}/npm/npmrc";
  # GTK2_RC_FILES="${config.xdg.configHome}/gtk-2.0/gtkrc";
  LESSHISTFILE="${config.xdg.stateHome}/less/history";
  WINEPREFIX="${config.xdg.dataHome}/wine";
  GTK_THEME="WhiteSur-Dark-solid";
  GTK_THEME_VARIANT="dark";
    };

home.sessionPath = [ "${config.home.sessionVariables.XDG_BIN_HOME}" ];
}
