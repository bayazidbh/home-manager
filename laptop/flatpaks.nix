{ config, pkgs, ... }:
{
config.services.flatpak = {
    enableModule = true;
    deduplicate = true;
    preRemotesCommand = ''
      /usr/bin/flatpak config  --user --set languages 'en;ja'
    '';
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "launcher-moe" = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
    };
    packages = [
     # "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
     # "flathub:app/io.github.flattool.Warehouse/x86_64/stable"
     # "flathub:app/io.github.dvlv.boxbuddyrs/x86_64/stable"
     # "flathub:app/it.mijorus.gearlever/x86_64/stable"

     "flathub:app/com.github.paolostivanin.OTPClient/x86_64/stable"
     "flathub:app/me.proton.Pass/x86_64/stable"
     "flathub:app/me.proton.Mail/x86_64/stable"
     "flathub:app/com.protonvpn.www/x86_64/stable"

     # "flathub:app/io.wavebox.Wavebox/x86_64/stable"
     "flathub:app/one.ablaze.floorp/x86_64/stable"
     "flathub:app/com.brave.Browser/x86_64/stable"
     # "flathub:app/com.github.micahflee.torbrowser-launcher/x86_64/stable"
     "flathub:app/org.qbittorrent.qBittorrent/x86_64/stable"

     "flathub:app/org.kde.gwenview/x86_64/stable"
     "flathub:app/org.kde.kcalc/x86_64/stable"
     "flathub:app/org.kde.filelight/x86_64/stable"
     "flathub:app/org.kde.krename/x86_64/stable"
     "flathub:app/org.kde.okular/x86_64/stable"


     "flathub:app/net.sourceforge.mcomix/x86_64/stable"
     "flathub:app/info.febvre.Komikku/x86_64/stable"

     "flathub:app/com.wps.Office/x86_64/stable"
     "flathub:app/org.onlyoffice.desktopeditors/x86_64/stable"
     "flathub:app/net.cozic.joplin_desktop/x86_64/stable"
     "flathub:app/org.standardnotes.standardnotes/x86_64/stable"
     "flathub:app/com.github.dynobo.normcap/x86_64/stable"
     "flathub:app/net.codeindustry.MasterPDFEditor/x86_64/stable"
     "flathub:app/com.github.johnfactotum.Foliate/x86_64/stable"

     "flathub:app/com.spotify.Client/x86_64/stable"
     # "flathub:app/org.soundconverter.SoundConverter/x86_64/stable"

     "flathub:app/com.stremio.Stremio/x86_64/stable"
     "flathub:app/info.smplayer.SMPlayer/x86_64/stable"
     # "flathub:app/org.videolan.VLC/x86_64/stable"
     # "flathub:app/io.github.aandrew_me.ytdn/x86_64/stable"
     # "flathub:app/no.mifi.losslesscut/x86_64/stable"

     "flathub:app/org.upscayl.Upscayl/x86_64/stable"
     # "flathub:app/page.codeberg.Imaginer.Imaginer/x86_64/stable"
     # "flathub:app/com.github.huluti.Curtail/x86_64/stable"
     # "flathub:app/net.fasterland.converseen/x86_64/stable"
     # "flathub:app/it.mijorus.collector/x86_64/stable"

     "flathub:app/io.gpt4all.gpt4all/x86_64/stable"
     # "flathub:app/io.github.Bavarder.Bavarder/x86_64/stable"

     # "flathub:app/de.wger.flutter/x86_64/stable"

     # "flathub:app/io.github.giantpinkrobots.bootqt/x86_64/stable"

     # "flathub:app/de.shorsh.discord-screenaudio/x86_64/stable"
     # "flathub:app/io.github.trigg.discover_overlay/x86_64/stable"

     "flathub:app/com.usebottles.bottles/x86_64/stable"
     # "flathub:app/org.winehq.Wine/x86_64/stable-23.08"
     "flathub:app/com.heroicgameslauncher.hgl/x86_64/stable"
     # "flathub:app/io.github.fastrizwaan.WineZGUI/x86_64/stable"
     # "flathub:app/net.lutris.Lutris/x86_64/stable"
     "flathub:app/io.itch.itch/x86_64/stable"

     # "flathub:app/com.valvesoftware.Steam/x86_64/stable"
     # "flathub:runtime/com.valvesoftware.Steam.Utility.steamtinkerlaunch/x86_64/stable"
     # "flathub:runtime/com.valvesoftware.Steam.Utility.thcrap_steam_proton_wrapper/x86_64/stable"
     "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
     "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"

     "flathub:app/io.github.Foldex.AdwSteamGtk/x86_64/stable"
     "flathub:app/com.steamgriddb.SGDBoop/x86_64/stable"
     "flathub:app/net.davidotek.pupgui2/x86_64/stable"
     "flathub:app/com.github.Matoking.protontricks/x86_64/stable"
     "flathub:app/io.github.philipk.boilr/x86_64/stable"

     "flathub:app/com.obsproject.Studio/x86_64/stable"
     "flathub:app/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
     "flathub:app/com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable"
     "flathub:app/com.obsproject.Studio.Plugin.Gstreamer/x86_64/stable"
     "flathub:app/com.obsproject.Studio.Plugin.GStreamerVaapi/x86_64/stable"
     "flathub:app/com.obsproject.Studio.Plugin.DroidCam/x86_64/stable"
     "flathub:app/com.obsproject.Studio.Plugin.BackgroundRemoval/x86_64/stable"

     "launcher-moe:app/moe.launcher.anime-games-launcher/x86_64/master"
    ];
    UNCHECKEDpostEverythingCommand = ''
      /usr/bin/rm ${config.xdg.dataHome}/flatpak/overrides
      /usr/bin/ln -sifv ${config.xdg.configHome}/home-manager/flatpak/overrides ${config.xdg.dataHome}/flatpak/
    '';
    #   /usr/bin/ln -sifv ${config.xdg.configHome}/flatpak/org.winehq.Wine.desktop ${config.xdg.dataHome}/flatpak/app/org.winehq.Wine/current/active/export/share/applications/
    #   /usr/bin/ln -s ${config.home.homeDirectory}/.var/app/com.valvesoftware.Steam/.steam ${config.home.homeDirectory}/.steam
  };
}
