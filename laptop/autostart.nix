{ config, pkgs, ... }:
{
systemd.user.tmpfiles.rules = [
  "L ${config.xdg.configHome}/autostart/com.valvesoftware.Steam.desktop - - - - ${config.xdg.configHome}/home-manager/laptop/autostart/com.valvesoftware.Steam.desktop"
  ];

systemd.user.services = {
  "autostart-kde-desktop-grid" = {
    Unit = {
      Description = "Autostart to KDE Desktop Grid";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStart = [
        "qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut ShowDesktopGrid"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-flatpak-wavebox" = {
    Unit = {
      Description = "Autostart Wavebox Flatpak App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 5";
      ExecStart = [
        "${config.home.sessionVariables.XDG_BIN_HOME}/wavebox-wayland"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-nix-brave" = {
    Unit = {
      Description = "Autostart Brave Nix App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 12";
      ExecStart = [
        "${config.home.sessionVariables.XDG_BIN_HOME}/brave-wayland"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-flatpak-wps" = {
    Unit = {
      Description = "Autostart WPS Flatpak App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 15";
      ExecStart = [
        "/usr/bin/bash -c \"/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=wps --file-forwarding com.wps.Office\""
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-win11-vm-console" = {
    Unit = {
      Description = "Autostart Win11 virt-manager console";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      };
    Service = {
      Type = "forking";
      Restart = "no";
      ExecStartPre = "/bin/sleep 20";
      ExecStart = "/usr/bin/virt-manager --connect qemu:///system --show-domain-console win11";
      };
    Install = {
      WantedBy = [ "graphical-session.target" ];
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

  # https://github.com/containers/podman/blob/main/docs/tutorials/socket_activation.md

  #   "podman.socket" = {
  #     Unit = {
  #       Description = "Podman API Socket";
  #       Documentation = "man:podman-system-service(1)";
  #       };
  #     Socket = {
  #       ListenStream = "%t/podman/podman.sock";
  #       SocketMode = "0660";
  #       };
  #     Install = {
  #       WantedBy = [ "sockets.target" ];
  #       };
  #     };
  #
  #   "echo.container" = {
  #     Unit = {
  #       Description = "Example echo service";
  #       Requires = "echo.socket";
  #       After = "echo.socket";
  #       };
  #     Container = {
  #       Image = "ghcr.io/eriksjolund/socket-activate-echo";
  #       Network = "none";
  #       };
  #     Install = {
  #       WantedBy = [ "default.target" ];
  #       };
  #     };
  #
  #   "echo.socket" = {
  #     Unit = {
  #       Description = "Example echo socket";
  #       };
  #     Socket = {
  #       ListenStream = [ "127.0.0.1:3000" "%h/echo_stream_sock" "[::1]:3000" "vsock:4294967295:3000" ];
  #       ListenDatagram = [ "127.0.0.1:3000" "[::1]:3000" ];
  #       };
  #     Install = {
  #       WantedBy = [ "sockets.target" ];
  #       };
  #     };
  };
}
