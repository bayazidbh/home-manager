{ config, pkgs, ... }:
{
  services.flatpak = {
    preInitCommand = ''
      /usr/bin/flatpak config  --user --set languages 'en;ja'
    '';
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "launcher-moe" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
    };
    packages = [
     "flathub:com.github.tchx84.Flatseal/x86_64/stable"
     "flathub:io.github.flattool.Warehouse/x86_64/stable"

     "flathub:io.wavebox.Wavebox/x86_64/stable"
     "flathub:com.github.micahflee.torbrowser-launcher/x86_64/stable"
     "flathub:org.qbittorrent.qBittorrent/x86_64/stable"

     "flathub:org.kde.gwenview/x86_64/stable"
     "flathub:org.kde.kcalc/x86_64/stable"
     "flathub:net.sourceforge.mcomix/x86_64/stable"
     "flathub:info.febvre.Komikku/x86_64/stable"

     "flathub:com.wps.Office/x86_64/stable"
     "flathub:net.cozic.joplin_desktop/x86_64/stable"
     "flathub:com.github.dynobo.normcap/x86_64/stable"
     "flathub:net.codeindustry.MasterPDFEditor/x86_64/stable"
     "flathub:io.github.btpf.alexandria/x86_64/stable"

     "flathub:com.spotify.Client/x86_64/stable"
     "flathub:org.soundconverter.SoundConverter/x86_64/stable"

     "flathub:com.stremio.Stremio/x86_64/stable"
     "flathub:info.smplayer.SMPlayer/x86_64/stable"
     "flathub:org.videolan.VLC/x86_64/stable"
     "flathub:io.github.aandrew_me.ytdn/x86_64/stable"
     "flathub:no.mifi.losslesscut/x86_64/stable"

     "flathub:org.upscayl.Upscayl/x86_64/stable"
     "flathub:page.codeberg.Imaginer.Imaginer/x86_64/stable"
     "flathub:com.github.huluti.Curtail/x86_64/stable"
     "flathub:net.fasterland.converseen/x86_64/stable"

     "flathub:io.github.Bavarder.Bavarder/x86_64/stable"

     "flathub:io.github.giantpinkrobots.bootqt/x86_64/stable"

     "flathub:de.shorsh.discord-screenaudio/x86_64/stable"
     "flathub:com.discordapp.Discord/x86_64/stable"
     "flathub:io.github.trigg.discover_overlay/x86_64/stable"

     "flathub:dev.lizardbyte.app.Sunshine/x86_64/stable"

     "flathub:com.heroicgameslauncher.hgl/x86_64/stable"
     "flathub:net.lutris.Lutris/x86_64/stable"
     "flathub:com.usebottles.bottles/x86_64/stable"
     "flathub:org.winehq.Wine/x86_64/stable-23.08"

     # "flathub:com.valvesoftware.Steam/x86_64/stable"
     # "flathub:com.valvesoftware.Steam.CompatibilityTool.Proton-GE/x86_64/stable"
     # "flathub:com.valvesoftware.Steam.Utility.steamtinkerlaunch/x86_64/stable"
     # "flathub:com.valvesoftware.Steam.Utility.thcrap_steam_proton_wrapper/x86_64/stable"
     "flathub:org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
     "flathub:com.valvesoftware.Steam.Utility.gamescope/x86_64/stable"
     "flathub:org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"

     "flathub:io.github.Foldex.AdwSteamGtk/x86_64/stable"
     "flathub:com.steamgriddb.SGDBoop/x86_64/stable"
     "flathub:net.davidotek.pupgui2/x86_64/stable"
     "flathub:com.github.Matoking.protontricks/x86_64/stable"

     "flathub:org.yuzu_emu.yuzu/x86_64/stable"
     "flathub:org.ryujinx.Ryujinx/x86_64/stable"
     "flathub:org.citra_emu.citra/x86_64/stable"
     "flathub:net.rpcs3.RPCS3/x86_64/stable"
     "flathub:net.pcsx2.PCSX2/x86_64/stable"

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
    postInitCommand = ''
      /usr/bin/rm ${config.xdg.dataHome}/flatpak/overrides
      /usr/bin/ln -sifv ${config.xdg.configHome}/home-manager/flatpak/overrides ${config.xdg.dataHome}/flatpak/
      /usr/bin/ln -sifv ${config.xdg.configHome}/flatpak/org.winehq.Wine.desktop ${config.xdg.dataHome}/flatpak/app/org.winehq.Wine/current/active/export/share/applications/
      /usr/bin/ln -s ${config.home.homeDirectory}/.var/app/com.valvesoftware.Steam/.steam ${config.home.homeDirectory}/.steam
    '';
  };

}
