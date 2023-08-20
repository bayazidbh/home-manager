{ config, pkgs, ... }:
{
systemd.user.services = {
  "autostart-wavebox-wayland" = {
    Unit = {
      Description = "Autostart Wavebox (Wayland)";
      After = "network.target";
      };
    Service = {
      ExecStart = "sleep 3 ; flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --extension-mime-request-handling=always-prompt-for-install --enable-features=WebRTCPipeWireCapturer,WebUIDarkMode,UseOzonePlatform,WaylandWindowDecoration --ozone-platform=wayland --force-dark-mode";
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
      ExecStart = "env GDK_DEBUG=portals GTK_USE_PORTAL=1 ${config.home.homeDirectory}/.nix-profile/bin/fsearch";
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
      ExecStart = "flatpak run --branch=stable --arch=x86_64 --command=joplin-desktop --file-forwarding net.cozic.joplin_desktop";
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
      ExecStart = "${config.home.homeDirectory}/.nix-profile/bin/rslsync --config '$(readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)'";
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
      ExecStart = "env HOME_DIR="${config.home.homeDirectory}/Documents/container/conty" "${config.home.homeDirectory}/.local/bin/conty.sh" --bind ${config.home.homeDirectory}/Storage ${config.home.homeDirectory}/Storage --bind ${config.home.homeDirectory}/Documents ${config.home.homeDirectory}/Documents --bind ${config.home.homeDirectory}/Downloads ${config.home.homeDirectory}/Downloads /usr/bin/fdm --hidden";
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
      ExecStart = "sleep 5 ; ${config.home.homeDirectory}/.local/bin/conty.sh /usr/bin/steam-runtime -nochatui -nofriendsui -silent";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
  };
}
