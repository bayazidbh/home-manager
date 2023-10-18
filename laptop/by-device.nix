{ config, pkgs, ... }:
{
home.sessionVariables = {
  HOST="bbh-laptop";
  HOSTNAME="bbh-laptop";
  };

home.packages = with pkgs; [
  podman podman-compose podman-desktop distrobox # containers stuff
  # downonspot spotify-qt # media viewers
  # mesa amdvlk driversi686Linux.amdvlk # wine graphics dependencies
  # wineWowPackages.stagingFull dxvk wineWowPackages.fonts winetricks # wine packages
  # gst_all_1.gstreamer gst_all_1.gst-vaapi gst_all_1.gst-libav gst_all_1.gstreamermm gst_all_1.gst-plugins-rs # gstreamer
  # gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly # gstreamer-plugins
  # gamescope gamemode # other gaming tools
  # steamtinkerlaunch gawk yad # steamtinkerlaunch deps
  ];

systemd.user.tmpfiles.rules = [
  "L ${config.xdg.configHome}/kwinrulesrc - - - - ${config.xdg.configHome}/home-manager/laptop/config/kwinrulesrc"
  "C ${config.xdg.configHome}/spectaclerc - - - - ${config.xdg.configHome}/home-manager/laptop/config/spectaclerc"
  "L ${config.xdg.configHome}/plasma-org.kde.plasma.desktop-appletsrc - - - - ${config.xdg.configHome}/home-manager/laptop/config/plasma-org.kde.plasma.desktop-appletsrc"
  "L ${config.xdg.configHome}/spectaclerc - - - - ${config.xdg.configHome}/home-manager/pc/config/spectaclerc"
  "d ${config.xdg.userDirs.pictures}/Archive"
  "d ${config.xdg.userDirs.pictures}/DCIM"
  "d ${config.home.homeDirectory}/Applications"
  "d ${config.home.homeDirectory}/Games"
  "d ${config.xdg.configHome}/heroic"
  "L ${config.xdg.configHome}/input-remapper-2 - - - - ${config.xdg.configHome}/home-manager/laptop/config/input-remapper-2"
  "d ${config.xdg.configHome}/heroic"
  "L ${config.xdg.configHome}/heroic/sideload_apps - - - - ${config.xdg.configHome}/home-manager/laptop/config/heroic/sideload_apps"
  "L ${config.xdg.configHome}/heroic/store - - - - ${config.xdg.configHome}/home-manager/laptop/config/heroic/store"
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
  "brave-nix-wl" = {
    name="Brave (Nix) (Wayland)";
    genericName="Web Browser";
    comment="Access the Internet";
    startupNotify=true;
    exec="brave --enable-features=UseOzonePlatform,Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,WaylandWindowDecoration,VaapiVideoEncoder,UseSkiaRenderer,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --ozone-platform=wayland --force-dark-mode %U";
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
        exec="brave --enable-features=UseOzonePlatform,Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,WaylandWindowDecoration,VaapiVideoEncoder,UseSkiaRenderer,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --ozone-platform=wayland --force-dark-mode";
        };
      "new-private-window" = {
        name="New Incognito Window";
        exec="brave --incognito --enable-features=UseOzonePlatform,Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,WaylandWindowDecoration,VaapiVideoEncoder,UseSkiaRenderer,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --ozone-platform=wayland --force-dark-mode";
        };
      };
    };
    "brave-nix-x11" = {
    name="Brave (Nix) (x11)";
    genericName="Web Browser";
    comment="Access the Internet";
    startupNotify=true;
    exec="brave --enable-features=Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --force-dark-mode %U";
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
        exec="brave --enable-features=Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --force-dark-mode";
        };
      "new-private-window" = {
        name="New Incognito Window";
        exec="brave --incognito --enable-features=Vulkan,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --enable-unsafe-webgpu --enable-gpu --force-dark-mode";
        };
      };
    };
  };
}
