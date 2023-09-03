{ config, pkgs, ... }:
{
home.sessionVariables = {
  HOST="bbh-laptop";
  HOSTNAME="bbh-laptop";
  };

home.file."autostart.sh" = {
  enable = true;
  target = ".local/bin/autostart.sh";
  executable = true;
  text = ''
    #!/usr/bin/bash

    sleep 8s ;
    flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --extension-mime-request-handling=always-prompt-for-install --enable-features=WebRTCPipeWireCapturer,WebUIDarkMode,UseOzonePlatform,WaylandWindowDecoration --ozone-platform=wayland --force-dark-mode &
    flatpak run --branch=stable --arch=x86_64 --command=joplin-desktop --file-forwarding net.cozic.joplin_desktop &
    flatpak run --branch=stable --arch=x86_64 --command=wps --file-forwarding com.wps.Office &
    env GDK_DEBUG=portals GTK_USE_PORTAL=1 ${config.home.homeDirectory}/.nix-profile/bin/fsearch &
    env HOME_DIR="${config.home.homeDirectory}/Documents/container/conty" "${config.home.homeDirectory}/.local/bin/conty.sh" --bind ${config.home.homeDirectory}/Storage ${config.home.homeDirectory}/Storage --bind ${config.home.homeDirectory}/Documents ${config.home.homeDirectory}/Documents --bind ${config.home.homeDirectory}/Downloads ${config.home.homeDirectory}/Downloads fdm --hidden &
    ${config.home.homeDirectory}/.nix-profile/bin/rslsync --config "$(readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)" &
    mkdir -p ${config.xdg.configHome}/duperemove/ ; ${config.home.homeDirectory}/.nix-profile/bin/duperemove -r -d --hashfile=${config.xdg.configHome}/duperemove/hashfile ${config.home.homeDirectory}/ &
    ${config.home.homeDirectory}/.local/bin/conty.sh steam -nochatui -nofriendsui -silent &
    env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /usr/bin/virt-manager --connect qemu:///system --show-domain-console win11 &
    podman start portainer &
    podman start freshrss &
    disown
    '';
  };

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
