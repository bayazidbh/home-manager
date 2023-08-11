{ config, pkgs, ... }:
{
  home.shellAliases = {

    # Environment shortcuts

    my_alias="bat -p -n --paging=never --style=header-filename /home/fenglengshun/.config/home-manager/default/alias.nix";
    update_desktop_files ="update-desktop-database ${config.home.homeDirectory}/.local/share/applications ${config.home.homeDirectory}/.nix-profile/share/applications /usr/local/share/applications /usr/share/applications -v " ;

    force-x11="export QT_QPA_PLATFORM=xcb ; export GDK_BACKEND=x11";
    force-portal="export GDK_DEBUG=portals ; export GTK_USE_PORTAL=1";

    ip-addr-show="ip addr show";
    ISO-today="echo '%{Date:yyyyMMdd}_%{Time:hhmmss}\ndate \"+%a %Y-%m-%d %H:%M:%S\"' ; date +'%a %Y-%m-%d %H:%M:%S'";
    kill_user="pkill -KILL -u $USER";

    # General file operation shortcuts

    batch-zip-subfolders = "echo 'for i in */; do zip -9 -r \"\${i%/}.zip\" \"\$i\" & done; wait'";
    batch-cbz-subfolders = "echo 'for i in */; do zip -9 -r \"\${i%/}.cbz\" \"\$i\" & done; wait'";
    unzip_jp="echo 'unzip -O SHIFT-JIS file.zip\nunzip -O CP936 file.zip'";

    convert_to_animated_image = "echo 'ffmpeg -i video_file -loop 0 output.gif\nffmpeg -i video_file -loop 0 output.webp'";
    append_images="echo 'appends the images vertically\nconvert -append in-*.jpg out.jpg\nappends the images horizontally\nconvert in-1.jpg in-5.jpg in-N.jpg +append out.jpg'";
    convert_to_pdf="echo 'soffice --headless --norestore --convert-to pdf --outdir {OUT_DIR} {FILE}\nlibreoffice --headless --convert-to pdf *.xlsx\nflatpak run org.libreoffice.LibreOffice --headless --convert-to pdf *.docx'";

    # Nix Package Manager shortcuts

    clean-nix="nix-env --delete-generations old ; nix-store --gc ; nix-collect-garbage -d ; nix-store --optimise";
    du-nix="nix-du -s=500MB | dot -Tpng > ~/Downloads/nix-store.png";

    # Conty Shortcuts https://github.com/Kron4ek/Conty

    conty-download="aria2c -d ${config.home.homeDirectory}/.local/bin https://github.com/bayazidbh/Conty/releases/download/continuous/conty.sh_part01 && aria2c -d ${config.home.homeDirectory}/.local/bin https://github.com/bayazidbh/Conty/releases/download/continuous/conty.sh_part02 && rmtrash -v ${config.home.homeDirectory}/.local/bin/conty.sh && cat ${config.home.homeDirectory}/.local/bin/conty.sh_part01 ${config.home.homeDirectory}/.local/bin/conty.sh_part02 > ${config.home.homeDirectory}/.local/bin/conty.sh ; chmod +x ${config.home.homeDirectory}/.local/bin/conty.sh ; rmtrash -rfv ${config.home.homeDirectory}/.local/bin/conty.sh_part* ; exa -al ${config.home.homeDirectory}/.local/bin";

    conty="HOME_DIR=${config.home.homeDirectory}/Documents/container/conty ${config.home.homeDirectory}/.local/bin/conty.sh --bind ${config.home.homeDirectory}/Games ${config.home.homeDirectory}/Games --bind ${config.home.homeDirectory}/Storage ${config.home.homeDirectory}/Storage --bind ${config.home.homeDirectory}/Documents ${config.home.homeDirectory}/Documents --bind ${config.home.homeDirectory}/Downloads ${config.home.homeDirectory}/Downloads";

    conty-export="HOME_DIR=${config.home.homeDirectory}/Documents/container/conty ${config.home.homeDirectory}/.local/bin/conty.sh -d --bind ${config.home.homeDirectory}/Games ${config.home.homeDirectory}/Games --bind ${config.home.homeDirectory}/Storage ${config.home.homeDirectory}/Storage --bind ${config.home.homeDirectory}/Documents ${config.home.homeDirectory}/Documents --bind ${config.home.homeDirectory}/Downloads ${config.home.homeDirectory}/Downloads && mv /home/fenglengshun/.local/share/applications/Conty /home/fenglengshun/.local/share/applications/Conty-Restricted && ${config.home.homeDirectory}/.local/bin/conty.sh -d && mv /home/fenglengshun/.local/share/applications/Conty /home/fenglengshun/.local/share/applications/Conty-Unrestricted && find /home/fenglengshun/.local/share/applications/Conty-Restricted -type f -exec sed -i 's/(Conty)/\(Conty-Restricted\)/g' {} + ; find /home/fenglengshun/.local/share/applications/Conty-Unrestricted -type f -exec sed -i 's/(Conty)/\(Conty-Unrestricted\)/g' {} +";

    contywine="WINEPREFIX=${config.home.homeDirectory}/.local/share/wineconty ${config.home.homeDirectory}/.local/bin/conty.sh wine";
    contywinejp="LC_ALL=ja_JP.UTF-8 TZ=Asia/Tokyo WINEPREFIX=${config.home.homeDirectory}/Games/Unlocked/_winejp/ WINEARCH=win32 ${config.home.homeDirectory}/.local/bin/conty.sh wine";
    contygamescope="WINEPREFIX=${config.home.homeDirectory}/.local/share/wineconty ${config.home.homeDirectory}/.local/bin/conty.sh gamescope -w 1477 -h 831 -W 1920 -H 1080 -r 60 -o 30 -f --fsr-upscaling --fsr-sharpness 10 -- wine";

    # Games
    steam-silent="steam -nochatui -nofriendsui -silent";
    gamescope_run="gamescope -w 1477 -h 831 -W 1920 -H 1080 -r 60 -o 30 -f --fsr-upscaling --fsr-sharpness 10 --steam --adaptive-sync --";
    winejp="LC_ALL=ja_JP.UTF-8 TZ=Asia/Tokyo WINEPREFIX=${config.home.homeDirectory}/Games/Unlocked/_winejp/ WINEARCH=win32 wine";
    nw="LD_PRELOAD=${config.home.homeDirectory}/Documents/Private/Linux/bin/nwjs-latest-linux-x64/libffmpeg.so ${config.home.homeDirectory}/Documents/Private/Linux/bin/nwjs-latest-linux-x64/nw";
    nw72="LD_PRELOAD=${config.home.homeDirectory}/Documents/Private/Linux/bin/nwjs-v0.72.0-linux-x64/libffmpeg.so ${config.home.homeDirectory}/Documents/Private/Linux/bin/nwjs-v0.72.0-linux-x64/nw";

    # Other flatpak management
    list-overrides-flatpak="bat -P --style=header,numbers,snip ${config.home.homeDirectory}/.local/share/flatpak/overrides/* ${config.xdg.configHome}/home-manager/flatpak/overrides/*";
    push-overrides-flatpak="cp -rfpv ${config.home.homeDirectory}/.local/share/flatpak/overrides ${config.xdg.configHome}/home-manager/flatpak/ ";
    pull-overrides-flatpak="cp -rfpv ${config.xdg.configHome}/home-manager/flatpak/overrides ${config.home.homeDirectory}/.local/share/flatpak";
  };
}
