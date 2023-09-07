{ config, pkgs, ... }:
{
home.sessionVariables = {
  HOST="bbh-laptop";
  HOSTNAME="bbh-laptop";
  };

home.packages = with pkgs; [
  podman podman-compose podman-desktop distrobox # containers stuff
  ];

systemd.user.tmpfiles.rules = [
  "d ${config.xdg.userDirs.pictures}/Archive"
  "d ${config.xdg.userDirs.pictures}/DCIM"
  "d ${config.home.homeDirectory}/Applications"
  "d ${config.home.homeDirectory}/Games"
  "d ${config.xdg.configHome}/heroic"
  "L ${config.xdg.configHome}/input-remapper-2 - - - - ${config.xdg.configHome}/home-manager/laptop/config/input-remapper-2"
  "d ${config.xdg.configHome}/heroic"
  "L ${config.xdg.configHome}/heroic/sideload_apps - - - - ${config.xdg.configHome}/home-manager/laptop/config/heroic/sideload_apps"
  "L ${config.xdg.configHome}/heroic/store - - - - ${config.xdg.configHome}/home-manager/laptop/config/heroic/store"
  ];Home}

home.file."resilio" = {
  enable = true;
  target = ".local/bin/resilio";
  executable = true;
  text = ''
    #!/usr/bin/bash

    # Get the resolved path of autostart.sh
    rslsync_config=$(readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)
    # Run rslsync with the resolved path as config
    ${config.home.homeDirectory}/.nix-profile/bin/rslsync --config $rslsync_config
    '';
  };

home.file."win11" = {
  enable = true;
  target = ".local/bin/win11";
  executable = true;
  text = ''
    #!/usr/bin/bash

    /usr/bin/virt-manager --connect qemu:///system --show-domain-console win11
    '';
  };
}
