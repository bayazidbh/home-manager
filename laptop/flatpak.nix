{ config, pkgs, ... }:
{
  services.flatpak = {
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "launcher-moe" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
    };
    packages = [
     "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
     "flathub:app/com.steamgriddb.SGDBoop/x86_64/stable"
     "flathub:app/com.stremio.Stremio/x86_64/stable"
     "flathub:app/com.usebottles.bottles/x86_64/stable"
     "flathub:app/com.wps.Office/x86_64/stable"
     "flathub:app/io.github.Foldex.AdwSteamGtk/x86_64/stable"
     "flathub:app/io.github.aandrew_me.ytdn/x86_64/stable"
     "flathub:app/io.wavebox.Wavebox/x86_64/stable"
     "flathub:app/net.codeindustry.MasterPDFEditor/x86_64/stable"
     "flathub:app/net.cozic.joplin_desktop/x86_64/stable"
     "flathub:app/org.upscayl.Upscayl/x86_64/stable"
     "flathub:app/org.videolan.VLC/x86_64/stable"
     "launcher-moe:app/moe.launcher.the-honkers-railway-launcher/x86_64/master"
     "launcher-moe:app/moe.launcher.an-anime-borb-launcher/x86_64/master"
     "launcher-moe:app/moe.launcher.an-anime-game-launcher/x86_64/master"
     "launcher-moe:app/moe.launcher.honkers-launcher/x86_64/master"
     "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/22.08"
     "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08"
    ];

    #preInitCommand = {
    #${config.home.homeDirectory}/.nix-profile/bin/aria2c --allow-overwrite -d ${config.xdg.configHome}/.config/home-manager/laptop https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-1.2.2-x86_64.flatpak
    #};
  };
}
