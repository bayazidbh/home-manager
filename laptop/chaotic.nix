{ chaotic, ... }:
{
  home.packages = [
    chaotic.packages.x86_64-linux.fastfetch # `${pkgs.hostPlatform.system}` may not work, unless you have manually adjusted it for this file
  ];
}
