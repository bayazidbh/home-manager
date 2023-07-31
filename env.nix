{ config, pkgs, ... }:

{

home.sessionVariables = {
    CARGO_HOME="${config.home.homeDirectory}/.local/share/cargo";
    NPM_CONFIG_USERCONFIG="${config.home.homeDirectory}/.config/npm/npmrc";
    GTK2_RC_FILES="${config.home.homeDirectory}/.config/gtk-2.0/gtkrc";
    LESSHISTFILE="${config.home.homeDirectory}/.local/state/less/history";
    WINEPREFIX="${config.home.homeDirectory}/.local/share/wine";
    GTK_THEME="WhiteSur-Dark-solid";
    GTK_THEME_VARIANT="dark";
    };
}
