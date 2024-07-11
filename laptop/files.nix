{ config, pkgs, ... }:
{
systemd.user.tmpfiles.rules = [
  "d ${config.xdg.userDirs.pictures}/Archive"
  "d ${config.xdg.userDirs.pictures}/DCIM"
  "d ${config.home.homeDirectory}/Applications"
  "d ${config.home.homeDirectory}/Games"
  "d ${config.xdg.configHome}/heroic"
  "L ${config.xdg.configHome}/kwinrulesrc - - - - ${config.xdg.configHome}/home-manager/laptop/config/kwinrulesrc"
  "C ${config.xdg.configHome}/spectaclerc - - - - ${config.xdg.configHome}/home-manager/laptop/config/spectaclerc"
  "L ${config.xdg.configHome}/plasma-org.kde.plasma.desktop-appletsrc - - - - ${config.xdg.configHome}/home-manager/laptop/config/plasma-org.kde.plasma.desktop-appletsrc"
  "L ${config.xdg.configHome}/input-remapper-2 - - - - ${config.xdg.configHome}/home-manager/laptop/config/input-remapper-2"
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

home.file."brave-wayland" = {
  enable = true;
  target = ".local/bin/brave-wayland";
  executable = true;
  text = ''
    #!/usr/bin/bash

    nixVulkanIntel nixGLIntel brave --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,WebUIDarkMode --extension-mime-request-handling=always-prompt-for-install --ozone-platform-hint=auto --force-dark-mode --enable-wayland-ime
    '';
  };

xdg.desktopEntries = {
  "brave-browser" = {
    name="Brave (Nix)";
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
  };
}
