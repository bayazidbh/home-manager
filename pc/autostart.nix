{ config, pkgs, ... }:
{
systemd.user.services = {
  "autostart-conty-wavebox" = {
    Unit = {
      Description = "Autostart Wavebox Flatpak App";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "forking";
      Restart = "no";
      ExecStartPre = "/bin/sleep 10";
      ExecStart = [
        "/usr/bin/bash -c \"${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh /opt/wavebox.io/wavebox/wavebox-launcher --extension-mime-request-handling=always-prompt-for-install --enable-features=WebRTCPipeWireCapturer,WebUIDarkMode,UseOzonePlatform,WaylandWindowDecoration --ozone-platform=wayland --force-dark-mode\""
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
