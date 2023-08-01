{ chaotic, ... }:
{
  home.packages = with chaotic.packages.x86_64-linux; [
    fastfetch gamescope_git
  ];
}
