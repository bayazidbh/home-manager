{ config, pkgs, ... }:
{
systemd.user.services = {
  "autostart-flatpak-wavebox" = {
    Unit = {
      Description = "Autostart Wavebox Flatpak App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 10";
      ExecStart = [
        "/usr/bin/bash -c \"/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --extension-mime-request-handling=always-prompt-for-install --enable-features=WebRTCPipeWireCapturer,WebUIDarkMode,UseOzonePlatform,WaylandWindowDecoration --ozone-platform=wayland --force-dark-mode\""
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

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
      Type = "notify";
      Restart = "yes";
      ExecStartPre = "/bin/sleep 5";
      ExecStart = [
        "${config.home.homeDirectory}/.nix-profile/bin/rslsync --config $(readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)"
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

  "autostart-conty-fdm" = {
    Unit = {
      Description = "Autostart Conty with Free Download Manager";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "notify";
      Restart = "no";
      ExecStartPre = "/bin/sleep 3";
      ExecStart = [
        "/usr/bin/bash -c \"/usr/bin/env HOME_DIR=${config.xdg.userDirs.documents}/container/conty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh --bind ${config.home.homeDirectory}/Storage ~/Storage --bind ${config.xdg.userDirs.documents} ~/Documents --bind ${config.home.homeDirectory}/Downloads ~/Downloads fdm --hidden\""
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-conty-steam" = {
    Unit = {
      Description = "Autostart Conty with Steam Runtime";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "no";
      ExecStartPre = "/bin/sleep 15";
      ExecStart = [
        "/usr/bin/bash -c \"${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh steam-runtime -nochatui -nofriendsui -silent\""
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

  "autostart-win11-vm-console" = {
    Unit = {
      Description = "Autostart Win11 virt-manager console";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      };
    Service = {
      Type = "simple";
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

  };
}
