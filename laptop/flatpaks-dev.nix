{ config, pkgs, ... }:
{
config.services.flatpak.flatpak = {
    enableModule = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "launcher-moe" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
    };
    packages = [
     "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"

     "flathub:app/io.wavebox.Wavebox/x86_64/stable"

     "flathub:app/com.spotify.Client/x86_64/stable"
     "flathub:app/com.stremio.Stremio/x86_64/stable"
     "flathub:app/info.smplayer.SMPlayer/x86_64/stable"
     "flathub:app/org.videolan.VLC/x86_64/stable"
     "flathub:app/io.github.aandrew_me.ytdn/x86_64/stable"
     "flathub:app/org.qbittorrent.qBittorrent/x86_64/stable"

     "flathub:app/com.wps.Office/x86_64/stable"
     "flathub:app/net.codeindustry.MasterPDFEditor/x86_64/stable"
     "flathub:app/com.github.dynobo.normcap/x86_64/stable"
     "flathub:app/net.codeindustry.MasterPDFEditor/x86_64/stable"
     "flathub:app/net.cozic.joplin_desktop/x86_64/stable"

     "flathub:app/org.upscayl.Upscayl/x86_64/stable"
     "flathub:app/page.codeberg.Imaginer.Imaginer/x86_64/stable"
     "flathub:app/io.github.Bavarder.Bavarder/x86_64/stable"
     "flathub:app/com.github.huluti.Curtail/x86_64/stable"
     "flathub:app/net.fasterland.converseen/x86_64/stable"

     "flathub:app/io.github.giantpinkrobots.bootqt/x86_64/stable"

     "flathub:app/de.shorsh.discord-screenaudio/x86_64/stable"
     "flathub:app/io.github.trigg.discover_overlay/x86_64/stable"

     "flathub:app/dev.lizardbyte.app.Sunshine/x86_64/stable"

     "flathub:app/com.heroicgameslauncher.hgl/x86_64/stable"
     "flathub:app/net.lutris.Lutris/x86_64/stable"
     "flathub:app/com.usebottles.bottles/x86_64/stable"
     "flathub:app/org.winehq.Wine/x86_64/stable-23.08"

     "flathub:app/com.valvesoftware.Steam/x86_64/stable"
     "flathub:runtime/com.valvesoftware.Steam.CompatibilityTool.Proton-GE/x86_64/stable"
     "flathub:runtime/com.valvesoftware.Steam.Utility.steamtinkerlaunch/x86_64/stable"
     "flathub:runtime/com.valvesoftware.Steam.Utility.thcrap_steam_proton_wrapper/x86_64/stable"
     "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
     "flathub:runtime/com.valvesoftware.Steam.Utility.gamescope/x86_64/stable"
     "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"

     "flathub:app/io.github.Foldex.AdwSteamGtk/x86_64/stable"
     "flathub:app/com.steamgriddb.SGDBoop/x86_64/stable"
     "flathub:app/net.davidotek.pupgui2/x86_64/stable"
     "flathub:app/com.github.Matoking.protontricks/x86_64/stable"

     "flathub:app/com.obsproject.Studio/x86_64/stable"
     "flathub:app/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
     "flathub:app/com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable"
     "flathub:app/com.obsproject.Studio.Plugin.Gstreamer/x86_64/stable"
     "flathub:app/com.obsproject.Studio.Plugin.GStreamerVaapi/x86_64/stable"
     "flathub:app/com.obsproject.Studio.Plugin.DroidCam/x86_64/stable"
     "flathub:app/com.obsproject.Studio.Plugin.BackgroundRemoval/x86_64/stable"

     "launcher-moe:moe.launcher.the-honkers-railway-launcher/x86_64/master"
    ];
    postInitCommand = "/usr/bin/ln -sifv ${config.xdg.configHome}/home-manager/flatpak/overrides ${config.xdg.dataHome}/flatpak/";
  };

}
