{ config, pkgs, ... }:
{
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
  "L ${config.xdg.configHome}/kwinrulesrc - - - - ${config.xdg.configHome}/home-manager/pc/config/kwinrulesrc"
  "C ${config.xdg.configHome}/spectaclerc - - - - ${config.xdg.configHome}/home-manager/pc/config/spectaclerc"
  "L ${config.xdg.configHome}/plasma-org.kde.plasma.desktop-appletsrc - - - - ${config.xdg.configHome}/home-manager/pc/config/plasma-org.kde.plasma.desktop-appletsrc"
  "L ${config.xdg.configHome}/spectaclerc - - - - ${config.xdg.configHome}/home-manager/pc/config/spectaclerc"
  "L ${config.xdg.configHome}/heroic/sideload_apps - - - - ${config.xdg.configHome}/home-manager/pc/config/heroic/sideload_apps"
  "L ${config.xdg.configHome}/heroic/store - - - - ${config.xdg.configHome}/home-manager/pc/config/heroic/store"
  "L ${config.home.homeDirectory}/.var/app/com.heroicgameslauncher.hgl/config/heroic/sideload_apps - - - - ${config.xdg.configHome}/home-manager/pc/config/flatpak/com.heroicgameslauncher.hgl/sideload_apps"
  "L ${config.home.homeDirectory}/.var/app/com.heroicgameslauncher.hgl/config/heroic/store - - - - ${config.xdg.configHome}/home-manager/pc/config/flatpak/com.heroicgameslauncher.hgl/store"
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

xdg.desktopEntries = {
  "brave-browser" = {
    name="Brave Web Browser";
    genericName="Web Browser";
    comment="Access the Internet";
    startupNotify=true;
    exec="nixVulkanIntel nixGLIntel brave --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --ozone-platform-hint=auto --force-dark-mode --enable-wayland-ime %U";
    terminal=false;
    icon="brave-desktop";
    type="Application";
    categories=[ "Network" "WebBrowser" ];
    mimeType=[ "application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/ipfs" "x-scheme-handler/ipns" ];
    settings={
      StartupWMClass ="brave-browser";
      };
    actions={
      "new-window" = {
        name="New Window";
        exec="nixVulkanIntel nixGLIntel brave --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --ozone-platform-hint=auto --force-dark-mode --enable-wayland-ime";
        };
      "new-private-window" = {
        name="New Incognito Window";
        exec="nixVulkanIntel nixGLIntel brave --incognito --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install ozone-platform-hint=auto --force-dark-mode --enable-wayland-ime";
        };
      };
    };
  #    "brave-nix-x11" = {
  #      name="Brave (Nix) (x11)";
  #      genericName="Web Browser";
  #      comment="Access the Internet";
  #      startupNotify=true;
  #      exec="nixGLIntel brave --enable-features=Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --force-dark-mode  --enable-wayland-ime %U";
  #      terminal=false;
  #      icon="brave-desktop";
  #      type="Application";
  #      categories=[ "Network" "WebBrowser" ];
  #      mimeType=[ "application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/ipfs" "x-scheme-handler/ipns" ];
  #      settings={
  #        StartupWMClass ="brave-browser";
  #        };
  #      actions={
  #        "new-window" = {
  #          name="New Window";
  #          exec="nixGLIntel brave --enable-features=Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --force-dark-mode  --enable-wayland-ime";
  #          };
  #        "new-private-window" = {
  #          name="New Incognito Window";
  #          exec="nixGLIntel brave --incognito --enable-features=Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --force-dark-mode  --enable-wayland-ime";
  #          };
  #        };
  #      };
  };
}
