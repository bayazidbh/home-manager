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

home.file."steam-silent" = {
  enable = true;
  target = ".local/bin/steam-silent";
  executable = true;
  text = ''
    #!/usr/bin/bash

    ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh steam -nochatui -nofriendsui -silent
    '';
  };

systemd.user.services = {
  "autostart-flatpak-joplin" = {
    Unit = {
      Description = "Autostart Joplin Flatpak App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 5";
      ExecStart = [
        "/usr/bin/bash -c \"/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=joplin-desktop --file-forwarding net.cozic.joplin_desktop\""
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

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
        "/usr/bin/bash -c \"/usr/bin/env GDK_DEBUG=portals GTK_USE_PORTAL=1 ${config.home.homeDirectory}/.nix-profile/bin/fsearch\""
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
      Restart = "yes";
      ExecStart = [
        "${config.home.sessionVariables.XDG_BIN_HOME}/resilio"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-nix-duperemove" = {
    Unit = {
      Description = "Autostart Duperemove Nix App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "notify";
      Restart = "no";
      ExecStartPre = "/bin/sleep 5";
      ExecStart = [
        "/usr/bin/bash -c \"/usr/bin/mkdir -p ${config.xdg.configHome}/duperemove/ ; ${config.home.homeDirectory}/.nix-profile/bin/duperemove -r -d --hashfile=${config.xdg.configHome}/duperemove/hashfile ${config.home.homeDirectory}/\""
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-conty-steam" = {
    Unit = {
      Description = "Autostart Resilio Sync Nix App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "forking";
      Restart = "yes";
      ExecStart = [
        "${config.home.sessionVariables.XDG_BIN_HOME}/steam-silent"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-dolphin" = {
    Unit = {
      Description = "Autostart KDE Dolphin File Manager";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 10";
      ExecStart = "/usr/bin/dolphin";
      };
    Install = {
      WantedBy = [ "graphical-session.target" ];
      };
    };

  # https://github.com/containers/podman/blob/main/docs/tutorials/socket_activation.md

  "podman.socket" = {
    Unit = {
      Description = "Podman API Socket";
      Documentation = "man:podman-system-service(1)";
      };
    Socket = {
      ListenStream = "%t/podman/podman.sock";
      SocketMode = "0660";
      };
    Install = {
      WantedBy = [ "sockets.target" ];
      };
    };

  "echo.container" = {
    Unit = {
      Description = "Example echo service";
      Requires = "echo.socket";
      After = "echo.socket";
      };
    Container = {
      Image = "ghcr.io/eriksjolund/socket-activate-echo";
      Network = "none";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };

  "echo.socket" = {
    Unit = {
      Description = "Example echo socket";
      };
    Socket = {
      ListenStream = [ "127.0.0.1:3000" "%h/echo_stream_sock" "[::1]:3000" "vsock:4294967295:3000" ];
      ListenDatagram = [ "127.0.0.1:3000" "[::1]:3000" ];
      };
    Install = {
      WantedBy = [ "sockets.target" ];
      };
    };

  #  "autostart-containers-portainer" = {
  #    Unit = {
  #      Description = "Autostart Containers with Portainer";
  #      PartOf = "graphical-session.target";
  #      After = "graphical-session.target";
  #    };
  #    Service = {
  #      Type = "simple";
  #      Restart = "no";
  #      ExecStartPre = "/bin/sleep 10";
  #      ExecStart = [
  #        "/usr/bin/bash -c \"${config.home.homeDirectory}/.nix-profile/bin/podman start portainer\""
  #      ];
  #    };
  #    Install = {
  #      WantedBy = [ "graphical-session.target" ];
  #    };
  #  };

  #  "autostart-containers-freshrss" = {
  #    Unit = {
  #      Description = "Autostart Containers with FreshRSS";
  #      PartOf = "graphical-session.target";
  #      After = "graphical-session.target";
  #    };
  #    Service = {
  #      Type = "simple";
  #      Restart = "no";
  #      ExecStartPre = "/bin/sleep 10";
  #      ExecStart = [
  #        "/usr/bin/bash -c \"${config.home.homeDirectory}/.nix-profile/bin/podman start freshrss\""
  #      ];
  #    };
  #    Install = {
  #      WantedBy = [ "graphical-session.target" ];
  #    };
  #  };

#  home.activation = {
#    pullSocketActivateEcho = {
#      after = [ "writeBoundary" ];
#      before = [ ];
#      data = "/usr/bin/command podman pull ghcr.io/eriksjolund/socket-activate-echo";
#      };
#    };

  };
}
