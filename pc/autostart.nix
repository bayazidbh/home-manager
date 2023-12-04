{ config, pkgs, ... }:
{

systemd.user.tmpfiles.rules = [
  "L ${config.xdg.configHome}/autostart/com.valvesoftware.Steam.desktop - - - - ${config.xdg.configHome}/home-manager/laptop/autostart/com.valvesoftware.Steam.desktop"
  ];

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
        "${config.home.sessionVariables.XDG_BIN_HOME}/wavebox-wayland"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  "autostart-nix-premid" = {
    Unit = {
      Description = "Autostart premid daemon";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      };
    Service = {
      Type = "simple";
      Restart = "always";
      ExecStartPre = "/bin/sleep 3";
      ExecStart = [
        "${config.home.homeDirectory}/.nix-profile/bin/nixGLIntel premid"
        ];
      };
    Install = {
      WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
