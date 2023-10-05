{ config, pkgs, ... }:
{
systemd.user.services = {
  "autostart-conty-wavebox" = {
    Unit = {
      Description = "Autostart Resilio Sync Nix App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "forking";
      Restart = "yes";
      ExecStart = [
        "${config.home.sessionVariables.XDG_BIN_HOME}/wavebox-wayland"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
