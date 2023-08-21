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

systemd.user.services = {
  "autostart-wps" = {
    Unit = {
      Description = "Autostart WPS Office";
      };
    Service = {
      ExecStart = "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=wps --file-forwarding com.wps.Office";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
  "autostart-win11-vm-console" = {
    Unit = {
      Description = "Autostart win11 virt-manager console";
      };
    Service = {
      ExecStart = "/usr/bin/env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /usr/bin/virt-manager --connect qemu:///system --show-domain-console win11";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
  "autostart-portainer" = {
    Unit = {
      Description = "Autostart Portainer with Podman";
      After = "network.target";
      };
    Service = {
      ExecStart = "${config.home.homeDirectory}/.nix-profile/bin/podman start portainer";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
    "autostart-freshrss" = {
    Unit = {
      Description = "Autostart FreshRSS Container";
      };
    Service = {
      ExecStart = "${config.home.homeDirectory}/.nix-profile/bin/podman start freshrss";
      };
    Install = {
      WantedBy = [ "default.target" ];
      };
    };
  };
}
