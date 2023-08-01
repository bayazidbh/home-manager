{ nixgl, pkgs, ... }:
{
  home.packages = with pkgs; [
    nixgl.packages.x86_64-linux.nixGLIntel nixgl.packages.x86_64-linux.nixVulkanIntel
  ];
}
