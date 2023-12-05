{ config, pkgs, ... }:
{
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
}
