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
      name = "IBM Plex Sans";
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

    # GTK 2 settings
    gtk2 = {
      extraConfig = ''
        gtk-enable-animations=1
        gtk-primary-button-warps-slider=0
        gtk-toolbar-style=3
        gtk-menu-images=1
        gtk-button-images=1
        gtk-cursor-theme-size=24
      '';
    };

    # GTK 3 settings
    gtk3 = {
      bookmarks = [
        "file://${config.home.homeDirectory}"
        "file://${config.xdg.userDirs.download}"
        "file://${config.xdg.userDirs.documents}"
        "file://${config.xdg.userDirs.documents}/Work"
        "file://${config.xdg.userDirs.pictures}"
      ];
      extraConfig = ''
        [Settings]
        gtk-application-prefer-dark-theme=true
        gtk-button-images=true
        gtk-cursor-theme-name=WhiteSur-cursors
        gtk-cursor-theme-size=24
        gtk-decoration-layout=close,minimize,maximize:icon
        gtk-enable-animations=true
        gtk-menu-images=true
        gtk-modules=colorreload-gtk-module:window-decorations-gtk-module:appmenu-gtk-module
        gtk-primary-button-warps-slider=false
        gtk-shell-shows-menubar=1
        gtk-theme-name=WhiteSur-Dark-solid
        gtk-toolbar-style=3
        gtk-xft-dpi=98304
      '';
      extraCss = ''
        @import 'colors.css';
      '';
    };

    # GTK 4 settings
    gtk4 = {
      extraConfig = ''
        [Settings]
        gtk-application-prefer-dark-theme=true
        gtk-cursor-theme-name=WhiteSur-cursors
        gtk-cursor-theme-size=24
        gtk-decoration-layout=close,minimize,maximize:icon
        gtk-enable-animations=true
        gtk-theme-name=WhiteSur-Dark-solid
        gtk-xft-dpi=98304
      '';
    };
  };

  home.file."gtkfilechooser.ini" = {
    enable = true;
    target = ".config/gtk-2.0/gtkfilechooser.ini";
    text = ''
      [Filechooser Settings]
      LocationMode=path-bar
      ShowHidden=false
      ShowSizeColumn=true
      GeometryX=486
      GeometryY=233
      GeometryWidth=948
      GeometryHeight=646
      SortColumn=name
      SortOrder=ascending
      StartupMode=recent
    '';
  };
  home.file."gtk-3.0-colors.css" = {
    enable = true;
    target = ".config/gtk-3.0/colors.css";
    text = ''
      @define-color borders_breeze #606060;
      @define-color content_view_bg_breeze #242424;
      @define-color error_color_backdrop_breeze #da4453;
      @define-color error_color_breeze #da4453;
      @define-color error_color_insensitive_backdrop_breeze #5f2d32;
      @define-color error_color_insensitive_breeze #5f2d32;
      @define-color insensitive_base_color_breeze #222222;
      @define-color insensitive_base_fg_color_breeze #606060;
      @define-color insensitive_bg_color_breeze #333333;
      @define-color insensitive_borders_breeze #414141;
      @define-color insensitive_fg_color_breeze #6c6c6c;
      @define-color insensitive_selected_bg_color_breeze #333333;
      @define-color insensitive_selected_fg_color_breeze #6c6c6c;
      @define-color insensitive_unfocused_bg_color_breeze #333333;
      @define-color insensitive_unfocused_fg_color_breeze #6c6c6c;
      @define-color insensitive_unfocused_selected_bg_color_breeze #333333;
      @define-color insensitive_unfocused_selected_fg_color_breeze #6c6c6c;
      @define-color link_color_breeze #315bef;
      @define-color link_visited_color_breeze #787878;
      @define-color success_color_backdrop_breeze #27ae60;
      @define-color success_color_breeze #27ae60;
      @define-color success_color_insensitive_backdrop_breeze #235036;
      @define-color success_color_insensitive_breeze #235036;
      @define-color theme_base_color_breeze #242424;
      @define-color theme_bg_color_breeze #363636;
      @define-color theme_button_background_backdrop_breeze #656565;
      @define-color theme_button_background_backdrop_insensitive_breeze #606060;
      @define-color theme_button_background_insensitive_breeze #606060;
      @define-color theme_button_background_normal_breeze #656565;
      @define-color theme_button_decoration_focus_backdrop_breeze #315bef;
      @define-color theme_button_decoration_focus_backdrop_insensitive_breeze #4f5d8e;
      @define-color theme_button_decoration_focus_breeze #315bef;
      @define-color theme_button_decoration_focus_insensitive_breeze #4f5d8e;
      @define-color theme_button_decoration_hover_backdrop_breeze #315bef;
      @define-color theme_button_decoration_hover_backdrop_insensitive_breeze #4f5d8e;
      @define-color theme_button_decoration_hover_breeze #315bef;
      @define-color theme_button_decoration_hover_insensitive_breeze #4f5d8e;
      @define-color theme_button_foreground_active_backdrop_breeze #dedede;
      @define-color theme_button_foreground_active_backdrop_insensitive_breeze #6c6c6c;
      @define-color theme_button_foreground_active_breeze #ffffff;
      @define-color theme_button_foreground_active_insensitive_breeze #6c6c6c;
      @define-color theme_button_foreground_backdrop_breeze #dedede;
      @define-color theme_button_foreground_backdrop_insensitive_breeze #898989;
      @define-color theme_button_foreground_insensitive_breeze #898989;
      @define-color theme_button_foreground_normal_breeze #dedede;
      @define-color theme_fg_color_breeze #dedede;
      @define-color theme_header_background_backdrop_breeze #333333;
      @define-color theme_header_background_breeze #363636;
      @define-color theme_header_background_light_breeze #363636;
      @define-color theme_header_foreground_backdrop_breeze #dedede;
      @define-color theme_header_foreground_breeze #dedede;
      @define-color theme_header_foreground_insensitive_backdrop_breeze #dedede;
      @define-color theme_header_foreground_insensitive_breeze #dedede;
      @define-color theme_hovering_selected_bg_color_breeze #ffffff;
      @define-color theme_selected_bg_color_breeze #315bef;
      @define-color theme_selected_fg_color_breeze #ffffff;
      @define-color theme_text_color_breeze #dedede;
      @define-color theme_titlebar_background_backdrop_breeze #333333;
      @define-color theme_titlebar_background_breeze #363636;
      @define-color theme_titlebar_background_light_breeze #363636;
      @define-color theme_titlebar_foreground_backdrop_breeze #dedede;
      @define-color theme_titlebar_foreground_breeze #dedede;
      @define-color theme_titlebar_foreground_insensitive_backdrop_breeze #dedede;
      @define-color theme_titlebar_foreground_insensitive_breeze #dedede;
      @define-color theme_unfocused_base_color_breeze #242424;
      @define-color theme_unfocused_bg_color_breeze #363636;
      @define-color theme_unfocused_fg_color_breeze #dedede;
      @define-color theme_unfocused_selected_bg_color_alt_breeze #263c88;
      @define-color theme_unfocused_selected_bg_color_breeze #263c88;
      @define-color theme_unfocused_selected_fg_color_breeze #dedede;
      @define-color theme_unfocused_text_color_breeze #dedede;
      @define-color theme_unfocused_view_bg_color_breeze #222222;
      @define-color theme_unfocused_view_text_color_breeze #606060;
      @define-color theme_view_active_decoration_color_breeze #315bef;
      @define-color theme_view_hover_decoration_color_breeze #315bef;
      @define-color tooltip_background_breeze #333333;
      @define-color tooltip_border_breeze #5e5e5e;
      @define-color tooltip_text_breeze #dedede;
      @define-color unfocused_borders_breeze #606060;
      @define-color unfocused_insensitive_borders_breeze #414141;
      @define-color warning_color_backdrop_breeze #f67400;
      @define-color warning_color_breeze #f67400;
      @define-color warning_color_insensitive_backdrop_breeze #683d16;
      @define-color warning_color_insensitive_breeze #683d16;
    '';
  };
  home.file."gtk-4.0-colors.css" = {
    enable = true;
    target = ".config/gtk-4.0/colors.css";
    text = ''
      @define-color borders_breeze #606060;
      @define-color content_view_bg_breeze #242424;
      @define-color error_color_backdrop_breeze #da4453;
      @define-color error_color_breeze #da4453;
      @define-color error_color_insensitive_backdrop_breeze #5f2d32;
      @define-color error_color_insensitive_breeze #5f2d32;
      @define-color insensitive_base_color_breeze #222222;
      @define-color insensitive_base_fg_color_breeze #606060;
      @define-color insensitive_bg_color_breeze #333333;
      @define-color insensitive_borders_breeze #414141;
      @define-color insensitive_fg_color_breeze #6c6c6c;
      @define-color insensitive_selected_bg_color_breeze #333333;
      @define-color insensitive_selected_fg_color_breeze #6c6c6c;
      @define-color insensitive_unfocused_bg_color_breeze #333333;
      @define-color insensitive_unfocused_fg_color_breeze #6c6c6c;
      @define-color insensitive_unfocused_selected_bg_color_breeze #333333;
      @define-color insensitive_unfocused_selected_fg_color_breeze #6c6c6c;
      @define-color link_color_breeze #315bef;
      @define-color link_visited_color_breeze #787878;
      @define-color success_color_backdrop_breeze #27ae60;
      @define-color success_color_breeze #27ae60;
      @define-color success_color_insensitive_backdrop_breeze #235036;
      @define-color success_color_insensitive_breeze #235036;
      @define-color theme_base_color_breeze #242424;
      @define-color theme_bg_color_breeze #363636;
      @define-color theme_button_background_backdrop_breeze #656565;
      @define-color theme_button_background_backdrop_insensitive_breeze #606060;
      @define-color theme_button_background_insensitive_breeze #606060;
      @define-color theme_button_background_normal_breeze #656565;
      @define-color theme_button_decoration_focus_backdrop_breeze #315bef;
      @define-color theme_button_decoration_focus_backdrop_insensitive_breeze #4f5d8e;
      @define-color theme_button_decoration_focus_breeze #315bef;
      @define-color theme_button_decoration_focus_insensitive_breeze #4f5d8e;
      @define-color theme_button_decoration_hover_backdrop_breeze #315bef;
      @define-color theme_button_decoration_hover_backdrop_insensitive_breeze #4f5d8e;
      @define-color theme_button_decoration_hover_breeze #315bef;
      @define-color theme_button_decoration_hover_insensitive_breeze #4f5d8e;
      @define-color theme_button_foreground_active_backdrop_breeze #dedede;
      @define-color theme_button_foreground_active_backdrop_insensitive_breeze #6c6c6c;
      @define-color theme_button_foreground_active_breeze #ffffff;
      @define-color theme_button_foreground_active_insensitive_breeze #6c6c6c;
      @define-color theme_button_foreground_backdrop_breeze #dedede;
      @define-color theme_button_foreground_backdrop_insensitive_breeze #898989;
      @define-color theme_button_foreground_insensitive_breeze #898989;
      @define-color theme_button_foreground_normal_breeze #dedede;
      @define-color theme_fg_color_breeze #dedede;
      @define-color theme_header_background_backdrop_breeze #333333;
      @define-color theme_header_background_breeze #363636;
      @define-color theme_header_background_light_breeze #363636;
      @define-color theme_header_foreground_backdrop_breeze #dedede;
      @define-color theme_header_foreground_breeze #dedede;
      @define-color theme_header_foreground_insensitive_backdrop_breeze #dedede;
      @define-color theme_header_foreground_insensitive_breeze #dedede;
      @define-color theme_hovering_selected_bg_color_breeze #ffffff;
      @define-color theme_selected_bg_color_breeze #315bef;
      @define-color theme_selected_fg_color_breeze #ffffff;
      @define-color theme_text_color_breeze #dedede;
      @define-color theme_titlebar_background_backdrop_breeze #333333;
      @define-color theme_titlebar_background_breeze #363636;
      @define-color theme_titlebar_background_light_breeze #363636;
      @define-color theme_titlebar_foreground_backdrop_breeze #dedede;
      @define-color theme_titlebar_foreground_breeze #dedede;
      @define-color theme_titlebar_foreground_insensitive_backdrop_breeze #dedede;
      @define-color theme_titlebar_foreground_insensitive_breeze #dedede;
      @define-color theme_unfocused_base_color_breeze #242424;
      @define-color theme_unfocused_bg_color_breeze #363636;
      @define-color theme_unfocused_fg_color_breeze #dedede;
      @define-color theme_unfocused_selected_bg_color_alt_breeze #263c88;
      @define-color theme_unfocused_selected_bg_color_breeze #263c88;
      @define-color theme_unfocused_selected_fg_color_breeze #dedede;
      @define-color theme_unfocused_text_color_breeze #dedede;
      @define-color theme_unfocused_view_bg_color_breeze #222222;
      @define-color theme_unfocused_view_text_color_breeze #606060;
      @define-color theme_view_active_decoration_color_breeze #315bef;
      @define-color theme_view_hover_decoration_color_breeze #315bef;
      @define-color tooltip_background_breeze #333333;
      @define-color tooltip_border_breeze #5e5e5e;
      @define-color tooltip_text_breeze #dedede;
      @define-color unfocused_borders_breeze #606060;
      @define-color unfocused_insensitive_borders_breeze #414141;
      @define-color warning_color_backdrop_breeze #f67400;
      @define-color warning_color_breeze #f67400;
      @define-color warning_color_insensitive_backdrop_breeze #683d16;
      @define-color warning_color_insensitive_breeze #683d16;
      '';
    };

  home.file = {
    "gtk-3.0-assets" = {
      enable = true;
      target = ".config/gtk-3.0/assets";
      source = "${./config/gtk/gtk-3.0/assets}";
    };
    "gtk-4.0-assets" = {
      enable = true;
      target = ".config/gtk-4.0/assets";
      source = "${./config/gtk/gtk-4.0/assets}";
    };
    "gtk-4.0-windows-assets" = {
      enable = true;
      target = ".config/gtk-4.0/windows-assets";
      source = "${./config/gtk/gtk-4.0/windows-assets}";
    };
    "gtk-4.0-gtk.css" = {
      enable = true;
      target = ".config/gtk-4.0/gtk.css";
      source = "${./config/gtk/gtk-4.0/gtk.css}";
    };
    "gtk-4.0-gtk-dark.css" = {
      enable = true;
      target = ".config/gtk-4.0/gtk-dark.css";
      source = "${./config/gtk/gtk-4.0/gtk-dark.css}";
    };
  };
}
