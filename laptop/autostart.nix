{ config, pkgs, ... }:
{
systemd.user.services = {
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
