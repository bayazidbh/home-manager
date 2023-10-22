{ config, pkgs, ... }:
{
  services.flatpak = {
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "launcher-moe" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
    };
    packages = [
     "flathub:com.github.tchx84.Flatseal/x86_64/stable"
     "flathub:com.steamgriddb.SGDBoop/x86_64/stable"
     "flathub:com.stremio.Stremio/x86_64/stable"
     "flathub:com.usebottles.bottles/x86_64/stable"
     "flathub:com.wps.Office/x86_64/stable"
     "flathub:io.github.Foldex.AdwSteamGtk/x86_64/stable"
     "flathub:io.github.aandrew_me.ytdn/x86_64/stable"
     "flathub:io.wavebox.Wavebox/x86_64/stable"
     "flathub:com.github.dynobo.normcap/x86_64/stable"
     "flathub:net.codeindustry.MasterPDFEditor/x86_64/stable"
     "flathub:net.cozic.joplin_desktop/x86_64/stable"
     "flathub:org.upscayl.Upscayl/x86_64/stable"
     "flathub:org.videolan.VLC/x86_64/stable"
     "flathub:page.codeberg.Imaginer.Imaginer/x86_64/stable"
     "flathub:io.github.Bavarder.Bavarder/x86_64/stable"
     "flathub:io.github.Foldex.AdwSteamGtk/x86_64/stable"
     "flathub:io.github.giantpinkrobots.bootqt/x86_64/stable"
     "flathub:com.github.huluti.Curtail/x86_64/stable"
     "flathub:net.fasterland.converseen/x86_64/stable"
     "flathub:de.shorsh.discord-screenaudio/x86_64/stable"
     "flathub:io.github.trigg.discover_overlay/x86_64/stable"
     "flathub:com.spotify.Client/x86_64/stable"
     "flathub:com.valvesoftware.Steam/x86_64/stable"
     "flathub:com.valvesoftware.Steam.CompatibilityTool.Proton-GE/x86_64/stable"
     "flathub:com.valvesoftware.Steam.Utility.thcrap_steam_proton_wrapper/x86_64/stable"
     "flathub:org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
     "flathub:com.valvesoftware.Steam.Utility.gamescope/x86_64/stable"
     "flathub:org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"
     "flathub:com.obsproject.Studio/x86_64/stable"
     "flathub:org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
     "flathub:com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable"
     "flathub:com.obsproject.Studio.Plugin.Gstreamer/x86_64/stable"
     "flathub:com.obsproject.Studio.Plugin.GStreamerVaapi/x86_64/stable"
     "flathub:com.obsproject.Studio.Plugin.DroidCam/x86_64/stable"
     "flathub:com.obsproject.Studio.Plugin.BackgroundRemoval/x86_64/stable"
     "launcher-moe:moe.launcher.the-honkers-railway-launcher/x86_64/master"
     "launcher-moe:moe.launcher.an-anime-game-launcher/x86_64/master"
     "launcher-moe:moe.launcher.honkers-launcher/x86_64/master"
     "launcher-moe:moe.launcher.an-anime-borb-launcher/x86_64/master"
    ];
    postInitCommand = "/usr/bin/ln -sifv ${config.xdg.configHome}/home-manager/flatpak/overrides ${config.xdg.dataHome}/flatpak/";
  };

}
