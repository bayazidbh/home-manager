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

    "sunshine" = {
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
