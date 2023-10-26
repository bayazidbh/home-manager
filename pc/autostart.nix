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
        "/usr/bin/bash -c \"flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --enable-features=UseOzonePlatform,Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,WaylandWindowDecoration,VaapiVideoEncoder,UseSkiaRenderer,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --ozone-platform=wayland --force-dark-mode\""
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
};
}
