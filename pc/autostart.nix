{ config, pkgs, ... }:
{

systemd.user.tmpfiles.rules = [
  "L ${config.xdg.configHome}/autostart/com.valvesoftware.Steam.desktop - - - - ${config.xdg.configHome}/home-manager/pc/autostart/com.valvesoftware.Steam.desktop"
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
      ExecStartPre = "/bin/sleep 3";
      ExecStart = [
        "${config.home.sessionVariables.XDG_BIN_HOME}/wavebox-wayland"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  "autostart-nix-arrpc" = {
    Unit = {
      Description = "Autostart arrpc daemon";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      Restart = "always";
      ExecStartPre = "/bin/sleep 3";
      ExecStart = [
        "${config.home.homeDirectory}/.nix-profile/bin/arrpc"
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
  "autostart-sunshine" = {
    Unit = {
      Description = "Sunshine self-hosted game stream host for Moonlight.";
      StartLimitIntervalSec = "500";
      StartLimitBurst = "5";
      };
    Service = {
      Restart = "on-failure";
      RestartSec = "5s";
      # root install
      # ExecStart = "/usr/bin/sunshine";
      # Flatpak Install
      ExecStart = "flatpak run dev.lizardbyte.app.Sunshine";
      ExecStop = "flatpak kill dev.lizardbyte.app.Sunshine";
      };
    Install = {
      WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
