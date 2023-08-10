{ config, pkgs, ... }:
{
  home.sessionVariables = {
    HOST="ostree-pc";
    HOSTNAME="ostree-pc";
    };

  systemd.user.tmpfiles.rules = [
  "L ${config.home.homeDirectory}/Documents/Downloads - - - - ${config.home.homeDirectory}/Downloads"
  "L ${config.home.homeDirectory}/Documents/Music - - - - ${config.home.homeDirectory}/Music"
  "L ${config.home.homeDirectory}/Documents/Pictures - - - - ${config.home.homeDirectory}/Pictures"
  "L ${config.xdg.configHome}/yuzu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/config"
  "L ${config.home.homeDirectory}/.local/share/yuzu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/data"
  "L ${config.xdg.configHome}/Ryujinx - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/Ryujinx/config"
  "L ${config.xdg.configHome}/citra-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/config"
  "L ${config.home.homeDirectory}/.local/share/citra-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/data"
  "L ${config.xdg.configHome}/dolphin-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/config"
  "L ${config.home.homeDirectory}/.local/share/dolphin-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/data"
  "L ${config.xdg.configHome}/PCSX2 - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/PCSX2/config"
  "L ${config.xdg.configHome}/rpcs3 - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/rpcs3/config"
  "L ${config.xdg.configHome}/ppsspp - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/ppsspp/config"
  "L ${config.home.homeDirectory}/Documents/container/conty/.config/yuzu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/config"
  "L ${config.home.homeDirectory}/Documents/container/conty/.local/share/yuzu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/data"
  "L ${config.home.homeDirectory}/Documents/container/conty/.config/Ryujinx - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/Ryujinx/config"
  "L ${config.home.homeDirectory}/Documents/container/conty/.config/citra-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/config"
  "L ${config.home.homeDirectory}/Documents/container/conty/.local/share/citra-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/data"
  "L ${config.home.homeDirectory}/Documents/container/conty/.config/dolphin-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/config"
  "L ${config.home.homeDirectory}/Documents/container/conty/.local/share/dolphin-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/data"
  "L ${config.home.homeDirectory}/Documents/container/conty/.config/PCSX2 - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/PCSX2/config"
  "L ${config.home.homeDirectory}/Documents/container/conty/.config/rpcs3 - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/rpcs3/config"
  "L ${config.home.homeDirectory}/Documents/container/conty/.config/ppsspp - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/ppsspp/config"
  ];

  home.file."autostart.sh" = {
    enable = true;
    target = ".local/bin/autostart.sh";
    executable = true;
    text = ''
    #!/usr/bin/bash
    sleep 15s
    flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox --extension-mime-request-handling=always-prompt-for-install --enable-features=WebRTCPipeWireCapturer,WebUIDarkMode,UseOzonePlatform,WaylandWindowDecoration --ozone-platform=wayland --force-dark-mode &
    flatpak run --branch=stable --arch=x86_64 --command=joplin-desktop --file-forwarding net.cozic.joplin_desktop &
    flatpak run --branch=stable --arch=x86_64 --command=wps --file-forwarding com.wps.Office &
    env GDK_DEBUG=portals GTK_USE_PORTAL=1 ${config.home.homeDirectory}/.nix-profile/bin/fsearch &
    env HOME_DIR="${config.home.homeDirectory}/Documents/container/conty" "${config.home.homeDirectory}/.local/bin/conty.sh" --bind ${config.home.homeDirectory}/Storage ${config.home.homeDirectory}/Storage --bind ${config.home.homeDirectory}/Documents ${config.home.homeDirectory}/Documents --bind ${config.home.homeDirectory}/Downloads ${config.home.homeDirectory}/Downloads /usr/bin/fdm --hidden &
    ${config.home.homeDirectory}/.nix-profile/bin/rslsync --config "$(readlink -f ${config.xdg.configHome}/rslsync/rslsync.conf)" &
    ${config.home.homeDirectory}/.nix-profile/bin/aw-qt &
    ${config.home.homeDirectory}/.local/bin/conty.sh /usr/bin/steam-runtime -nochatui -nofriendsui -silent &
    env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /usr/bin/virt-manager --connect qemu:///system --show-domain-console win10 &
    podman start portainer &
    podman start freshrss &
    disown

    '';
  };
}
