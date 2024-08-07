{ config, pkgs, ... }:
{
home.file."resilio" = {
  enable = true;
  target = ".local/bin/resilio";
  executable = true;
  text = ''
    #!/usr/bin/bash

    # Get the resolved path of autostart.sh
    rslsync_config=$(readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)
    # Run rslsync with the resolved path as config
    ${config.home.homeDirectory}/.nix-profile/bin/rslsync --config $rslsync_config
    '';
  };

#  home.file."steam-conty-silent" = {
#    enable = true;
#    target = ".local/bin/steam-conty-silent";
#    executable = true;
#    text = ''
#      #!/usr/bin/bash
#
#      ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh steam -nochatui -nofriendsui -silent
#
#      '';
#    };

systemd.user.services = {
  "autostart-nix-fsearch" = {
    Unit = {
      Description = "Autostart FSearch Nix App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 8";
      ExecStart = [
        "/usr/bin/bash -c \"/usr/bin/env GDK_DEBUG=portals GTK_USE_PORTAL=1 QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 ${config.home.homeDirectory}/.nix-profile/bin/fsearch\""
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-nix-rslsync" = {
    Unit = {
      Description = "Autostart Resilio Sync Nix App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "forking";
      Restart = "always";
      RestartSec = "3";
      ExecStart = [
        "${config.home.sessionVariables.XDG_BIN_HOME}/resilio"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

#    "autostart-nix-duperemove" = {
#      Unit = {
#        Description = "Autostart Duperemove Nix App";
#        PartOf = "graphical-session.target";
#        After = "graphical-session.target";
#      };
#      Service = {
#        Type = "simple";
#        Restart = "no";
#        ExecStartPre = "/bin/sleep 5";
#        ExecStart = [
#          "/usr/bin/bash -c \"/usr/bin/mkdir -p ${config.xdg.configHome}/duperemove/ ; ${config.home.homeDirectory}/.nix-profile/bin/duperemove -r -d --hashfile=${config.xdg.configHome}/duperemove/hashfile ${config.home.homeDirectory}/\""
#        ];
#      };
#      Install = {
#        WantedBy = [ "graphical-session.target" ];
#      };
#    };

  "autostart-dolphin" = {
    Unit = {
      Description = "Autostart KDE Dolphin File Manager";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 5";
      ExecStart = "/usr/bin/dolphin";
      };
    Install = {
      WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
