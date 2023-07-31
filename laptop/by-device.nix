{ config, pkgs, ... }:
{
  home.sessionVariables = {
    HOST="neon-laptop";
    HOSTNAME="neon-laptop";
    };

  systemd.user.tmpfiles.rules = [
  "L ${config.home.homeDirectory}/Documents/Downloads - - - - ${config.home.homeDirectory}/Downloads"
  "L ${config.home.homeDirectory}/Documents/Music - - - - ${config.home.homeDirectory}/Music"
  "L ${config.home.homeDirectory}/Documents/Pictures - - - - ${config.home.homeDirectory}/Pictures"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/config - - - - ${config.home.homeDirectory}/.config/yuzu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/data - - - - ${config.home.homeDirectory}/.local/share/yuzu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/Ryujinx/config - - - - ${config.home.homeDirectory}/.config/Ryujinx"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/config - - - - ${config.home.homeDirectory}/.config/citra-emu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/data - - - - ${config.home.homeDirectory}/.local/share/citra-emu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/config - - - - ${config.home.homeDirectory}/.config/dolphin-emu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/data - - - - ${config.home.homeDirectory}/.local/share/dolphin-emu"
  "L ${config.home.homeDirectory}/Games/Emulation/Sony/emu/PCSX2/config - - - - ${config.home.homeDirectory}/.config/PCSX2"
  "L ${config.home.homeDirectory}/Games/Emulation/Sony/emu/rpcs3/config - - - - ${config.home.homeDirectory}/.config/rpcs3"
  "L ${config.home.homeDirectory}/Games/Emulation/Sony/emu/ppsspp/config - - - - ${config.home.homeDirectory}/.config/ppsspp"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/config - - - - ${config.home.homeDirectory}/Documents/container/conty/.config/yuzu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/data - - - - ${config.home.homeDirectory}/Documents/container/conty/.local/share/yuzu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/Ryujinx/config - - - - ${config.home.homeDirectory}/Documents/container/conty/.config/Ryujinx"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/config - - - - ${config.home.homeDirectory}/Documents/container/conty/.config/citra-emu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/data - - - - ${config.home.homeDirectory}/Documents/container/conty/.local/share/citra-emu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/config - - - - ${config.home.homeDirectory}/Documents/container/conty/.config/dolphin-emu"
  "L ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/data - - - - ${config.home.homeDirectory}/Documents/container/conty/.local/share/dolphin-emu"
  "L ${config.home.homeDirectory}/Games/Emulation/Sony/emu/PCSX2/config - - - - ${config.home.homeDirectory}/Documents/container/conty/.config/PCSX2"
  "L ${config.home.homeDirectory}/Games/Emulation/Sony/emu/rpcs3/config - - - - ${config.home.homeDirectory}/Documents/container/conty/.config/rpcs3"
  "L ${config.home.homeDirectory}/Games/Emulation/Sony/emu/ppsspp/config - - - - ${config.home.homeDirectory}/Documents/container/conty/.config/ppsspp"
  ];

  home.file."autostart.sh" = {
    enable = true;
    target = ".local/bin/autostart.sh";
    executable = true;
    text = ''
    #!/usr/bin/bash
    sleep 15s
    flatpak run --branch=master --arch=x86_64 --command=pwbypass org.kde.xwaylandvideobridge &
    flatpak run --branch=stable --arch=x86_64 --command=wavebox --file-forwarding io.wavebox.Wavebox @@u %U @@ &
    flatpak run --branch=stable --arch=x86_64 --command=joplin-desktop --file-forwarding net.cozic.joplin_desktop @@u %u @@ &
    env GDK_DEBUG=portals GTK_USE_PORTAL=1 ${config.home.homeDirectory}/.nix-profile/bin/fsearch &
    env HOME_DIR="${config.home.homeDirectory}/Documents/container/conty" "${config.home.homeDirectory}/.local/bin/conty.sh" --bind ${config.home.homeDirectory}/Storage ${config.home.homeDirectory}/Storage --bind ${config.home.homeDirectory}/Documents ${config.home.homeDirectory}/Documents --bind ${config.home.homeDirectory}/Downloads ${config.home.homeDirectory}/Downloads /usr/bin/fdm --hidden &
    ${config.home.homeDirectory}/.nix-profile/bin/rslsync --config ~/.config/rslsync/rslsync.conf &
    ${config.home.homeDirectory}/.nix-profile/bin/aw-qt &
    ${config.home.homeDirectory}/.local/bin/conty.sh /usr/bin/steam-runtime -nochatui -nofriendsui -silent &
    env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /usr/bin/virt-manager --connect qemu:///system --show-domain-console win10 &
    podman start portainer &
    podman start freshrss &
    disown
    '';
  };
}
