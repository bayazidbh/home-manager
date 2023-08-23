{ config, pkgs, ... }:
{
systemd.user.services = {
  "autostart-wavebox-wayland" = {
    Unit = {
      Description = "Autostart Wavebox (Wayland)";
      After = "network.target";
      };
    Service = {
      ExecStart = "/usr/bin/bash -c \"/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --extension-mime-request-handling=always-prompt-for-install --enable-features=WebRTCPipeWireCapturer,WebUIDarkMode,UseOzonePlatform,WaylandWindowDecoration --ozone-platform=wayland --force-dark-mode\"";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
  "autostart-fsearch" = {
    Unit = {
      Description = "Autostart FSearch";
      };
    Service = {
      ExecStart = "/usr/bin/bash -c \"/usr/bin/env GDK_DEBUG=portals GTK_USE_PORTAL=1 ${config.home.homeDirectory}/.nix-profile/bin/fsearch\"";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
  "autostart-joplin" = {
    Unit = {
      Description = "Autostart Joplin";
      After = "network.target";
      };
    Service = {
      ExecStart = "/usr/bin/bash -c \"/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=joplin-desktop --file-forwarding net.cozic.joplin_desktop\"";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
    "autostart-resilio" = {
    Unit = {
      Description = "Autostart Resilio Sync";
      After = "network.target";
      };
    Service = {
      ExecStart = "/usr/bin/bash -c \"${config.home.homeDirectory}/.nix-profile/bin/rslsync --config $(/usr/bin/readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)\"";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
    "autostart-fdm" = {
    Unit = {
      Description = "Autostart Free Download Manager";
      After = "network.target";
      };
    Service = {
      ExecStart = "/usr/bin/bash -c \"/usr/bin/env HOME_DIR=${config.xdg.userDirs.documents}/container/conty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh --bind ${config.home.homeDirectory}/Storage ~/Storage --bind ${config.xdg.userDirs.documents} ~/Documents --bind ${config.home.homeDirectory}/Downloads ~/Downloads fdm --hidden\"";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
    "autostart-steam" = {
    Unit = {
      Description = "Autostart Steam (Hidden)";
      After = "network.target";
      };
    Service = {
      ExecStart = "/usr/bin/bash -c \"${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh steam-runtime -nochatui -nofriendsui -silent\"";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
    "duperemover" = {
    Unit = {
      Description = "Autostart duperemove";
      };
    Service = {
      ExecStart = "/usr/bin/bash -c \"/usr/bin/mkdir -p ${config.xdg.configHome}/duperemove/ ; ${config.home.homeDirectory}/.nix-profile/bin/duperemove -r -d --hashfile=${config.xdg.configHome}/duperemove/hashfile ${config.home.homeDirectory}/\"";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
  };
}
