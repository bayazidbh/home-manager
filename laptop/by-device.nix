{ config, pkgs, ... }:
{
home.sessionVariables = {
  HOST="bbh-laptop";
  HOSTNAME="bbh-laptop";
  };

systemd.user.tmpfiles.rules = [
  "L ${config.home.homeDirectory}/Documents/Downloads - - - - ${config.home.homeDirectory}/Downloads"
  "L ${config.home.homeDirectory}/Documents/Music - - - - ${config.home.homeDirectory}/Music"
  "L ${config.home.homeDirectory}/Documents/Pictures - - - - ${config.home.homeDirectory}/Pictures"
  "L ${config.home.homeDirectory}/Documents/Videos - - - - ${config.home.homeDirectory}/Videos"
  ];

home.file."autostart.sh" = {
  enable = true;
  target = ".local/bin/autostart.sh";
  executable = true;
  text = ''
    #!/usr/bin/bash

    sleep 8s ;
    flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --extension-mime-request-handling=always-prompt-for-install --enable-features=WebRTCPipeWireCapturer,WebUIDarkMode,UseOzonePlatform,WaylandWindowDecoration --ozone-platform=wayland --force-dark-mode &
    flatpak run --branch=stable --arch=x86_64 --command=joplin-desktop --file-forwarding net.cozic.joplin_desktop &
    flatpak run --branch=stable --arch=x86_64 --command=wps --file-forwarding com.wps.Office &
    env GDK_DEBUG=portals GTK_USE_PORTAL=1 ${config.home.homeDirectory}/.nix-profile/bin/fsearch &
    env HOME_DIR="${config.home.homeDirectory}/Documents/container/conty" "${config.home.homeDirectory}/.local/bin/conty.sh" --bind ${config.home.homeDirectory}/Storage ${config.home.homeDirectory}/Storage --bind ${config.home.homeDirectory}/Documents ${config.home.homeDirectory}/Documents --bind ${config.home.homeDirectory}/Downloads ${config.home.homeDirectory}/Downloads fdm --hidden &
    ${config.home.homeDirectory}/.nix-profile/bin/rslsync --config "$(readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)" &
    mkdir -p ${config.xdg.configHome}/duperemove/ ; ${config.home.homeDirectory}/.nix-profile/bin/duperemove -r -d --hashfile=${config.xdg.configHome}/duperemove/hashfile ${config.home.homeDirectory}/ &
    ${config.home.homeDirectory}/.local/bin/conty.sh steam -nochatui -nofriendsui -silent &
    env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /usr/bin/virt-manager --connect qemu:///system --show-domain-console win11 &
    podman start portainer &
    podman start freshrss &
    disown
    '';
  };

home.file."resilio" = {
  enable = true;
  target = ".local/bin/resilio";
  executable = true;
  text = ''
    #!/usr/bin/bash

    ${config.home.homeDirectory}/.nix-profile/bin/rslsync --config $(readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)
    '';
  };

home.file."win11" = {
  enable = true;
  target = ".local/bin/win11";
  executable = true;
  text = ''
    #!/usr/bin/bash

    /usr/bin/virt-manager --connect qemu:///system --show-domain-console win11
    '';
  };

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
      Restart = "no";
      Environment = "RESILIO_CONFIG=$(/bin/readlink -f /home/fenglengshun/.config/rslsync/rslsync.conf)";
      ExecStartPre = "/bin/sleep 5";
      ExecStart = [
        " ${config.home.homeDirectory}/.nix-profile/bin/rslsync --config $RESILIO_CONFIG"
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
      Environment = "HOME_DIR=${config.xdg.userDirs.documents}/container/conty";
      ExecStartPre = "/bin/sleep 3";
      ExecStart = [
        "/usr/bin/bash -c \"${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh --bind ${config.home.homeDirectory}/Storage ~/Storage --bind ${config.xdg.userDirs.documents} ~/Documents --bind ${config.home.homeDirectory}/Downloads ~/Downloads fdm --hidden\""
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
      Type = "forking";
      Restart = "no";
      ExecStartPre = "/bin/sleep 20";
      ExecStart = "${config.home.sessionVariables.XDG_BIN_HOME}/win11";
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
