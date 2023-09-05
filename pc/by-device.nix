{ config, pkgs, ... }:
{
home.sessionVariables = {
  HOST="bbh-pc";
  HOSTNAME="bbh-pc";
  };

home.packages = with pkgs; [
    distrobox podman-compose # podman # containers stuff
    # downonspot spotify-qt # media viewers
    mesa amdvlk driversi686Linux.amdvlk # wine graphics dependencies
    wineWowPackages.stagingFull dxvk wineWowPackages.fonts winetricks # wine packages
    gst_all_1.gstreamer gst_all_1.gst-vaapi gst_all_1.gst-libav gst_all_1.gstreamermm gst_all_1.gst-plugins-rs # gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly # gstreamer-plugins
    # steamtinkerlaunch gawk yad # steamtinkerlaunch deps
  ];

systemd.user.tmpfiles.rules = [
  "L ${config.xdg.userDirs.download}/Storage - - - - ${config.home.homeDirectory}/Storage/Data/Downloads"
  "L ${config.xdg.userDirs.documents}/Storage - - - - ${config.home.homeDirectory}/Storage/Data/Documents"
  "L ${config.xdg.userDirs.music}/Storage - - - - ${config.home.homeDirectory}/Storage/Data/Music"
  "L ${config.xdg.userDirs.pictures}/Storage - - - - ${config.home.homeDirectory}/Storage/Data/Pictures"
  "L ${config.xdg.userDirs.videos}/Storage - - - - ${config.home.homeDirectory}/Storage/Data/Videos"
  "L ${config.xdg.userDirs.documents}/Media - - - - ${config.home.homeDirectory}/Storage/Data/Media"
  "L ${config.home.homeDirectory}/Applications - - - - ${config.home.homeDirectory}/Storage/Data/Applications"
  "L ${config.home.homeDirectory}/Games - - - - ${config.home.homeDirectory}/Storage/Data/Media/Games"
  "L ${config.xdg.configHome}/yuzu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/config"
  "L ${config.xdg.dataHome}/yuzu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/data"
  "L ${config.xdg.configHome}/Ryujinx - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/Ryujinx/config"
  "L ${config.xdg.configHome}/citra-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/config"
  "L ${config.xdg.dataHome}/citra-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/data"
  "L ${config.xdg.configHome}/dolphin-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/config"
  "L ${config.xdg.dataHome}/dolphin-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/data"
  "L ${config.xdg.configHome}/PCSX2 - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/PCSX2/config"
  "L ${config.xdg.configHome}/rpcs3 - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/rpcs3/config"
  "L ${config.xdg.configHome}/ppsspp - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/ppsspp/config"
  "L ${config.xdg.userDirs.documents}/container/conty/.config/yuzu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/config"
  "L ${config.xdg.userDirs.documents}/container/conty/.local/share/yuzu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/yuzu/data"
  "L ${config.xdg.userDirs.documents}/container/conty/.config/Ryujinx - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/Ryujinx/config"
  "L ${config.xdg.userDirs.documents}/container/conty/.config/citra-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/config"
  "L ${config.xdg.userDirs.documents}/container/conty/.local/share/citra-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/citra-emu/data"
  "L ${config.xdg.userDirs.documents}/container/conty/.config/dolphin-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/config"
  "L ${config.xdg.userDirs.documents}/container/conty/.local/share/dolphin-emu - - - - ${config.home.homeDirectory}/Games/Emulation/Nintendo/emu/dolphin-emu/data"
  "L ${config.xdg.userDirs.documents}/container/conty/.config/PCSX2 - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/PCSX2/config"
  "L ${config.xdg.userDirs.documents}/container/conty/.config/rpcs3 - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/rpcs3/config"
  "L ${config.xdg.userDirs.documents}/container/conty/.config/ppsspp - - - - ${config.home.homeDirectory}/Games/Emulation/Sony/emu/ppsspp/config"
  "L ${config.xdg.configHome}/input-remapper-2 - - - - ${config.xdg.configHome}/home-manager/pc/config/input-remapper-2"
  "L ${config.xdg.configHome}/heroic/sideload_apps - - - - ${config.xdg.configHome}/home-manager/pc/config/heroic/sideload_apps"
  "L ${config.xdg.configHome}/heroic/store - - - - ${config.xdg.configHome}/home-manager/pc/config/heroic/store"
  ];

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
