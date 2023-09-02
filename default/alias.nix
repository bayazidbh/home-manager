{ config, pkgs, ... }:
{
  home.shellAliases = {

    # Environment shortcuts

    my_alias="bat -p -n --paging=never --style=header-filename ${config.xdg.configHome}/home-manager/default/alias.nix";
    update_desktop_files ="update-desktop-database ${config.xdg.dataHome}/applications ${config.home.homeDirectory}/.nix-profile/share/applications /usr/local/share/applications /usr/share/applications -v " ;
    wget="wget --hsts-file=\"${config.xdg.dataHome}/wget-hsts\"";

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

    conty-download="rm -rfv ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh_part* ;
                    aria2c -d ${config.home.sessionVariables.XDG_BIN_HOME} https://github.com/bayazidbh/Conty/releases/download/continuous/conty.sh_part01 && \
                    aria2c -d ${config.home.sessionVariables.XDG_BIN_HOME} https://github.com/bayazidbh/Conty/releases/download/continuous/conty.sh_part02 && \
                    rmtrash -v ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh && \
                    cat ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh_part01 ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh_part02 > ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh ; \
                    chmod +x ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh ; \
                    rmtrash -rfv ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh_part* ; exa -al ${config.home.sessionVariables.XDG_BIN_HOME}";

    conty="HOME_DIR=${config.xdg.userDirs.documents}/container/conty WINEPREFIX=${config.xdg.dataHome}/wineconty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh --bind ${config.home.homeDirectory}/Games ~/Games --bind ${config.home.homeDirectory}/Storage ~/Storage --bind ${config.xdg.userDirs.documents} ~/Documents --bind ${config.xdg.userDirs.download} ~/Downloads";

    conty-export="rmtrash -rfv ~/.local/share/applications/Conty* ; HOME_DIR=${config.xdg.userDirs.documents}/container/conty WINEPREFIX=${config.xdg.dataHome}/wineconty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh -d --bind ${config.home.homeDirectory}/Games ~/Games --bind ${config.home.homeDirectory}/Storage ~/Storage --bind ${config.xdg.userDirs.documents} ~/Documents --bind ${config.xdg.userDirs.download} ~/Downloads && mv -f ${config.xdg.dataHome}/applications/Conty ${config.xdg.dataHome}/applications/Conty-Restricted && ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh -d && mv -f ${config.xdg.dataHome}/applications/Conty ${config.xdg.dataHome}/applications/Conty-Unrestricted && find ${config.xdg.dataHome}/applications/Conty-Restricted -type f -exec sed -i 's/(Conty)/\(Conty-Restricted\)/g' {} + ; find ${config.xdg.dataHome}/applications/Conty-Unrestricted -type f -exec sed -i 's/(Conty)/\(Conty-Unrestricted\)/g' {} +";

    contywine="WINEPREFIX=${config.xdg.dataHome}/wineconty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh wine";
    contywinejp="LC_ALL=ja_JP.UTF-8 TZ=Asia/Tokyo WINEPREFIX=${config.home.homeDirectory}/Games/Unlocked/_winejp/ WINEARCH=win32 ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh wine";
    contygamescope="WINEPREFIX=${config.xdg.dataHome}/wineconty ${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh gamescope -w 1477 -h 831 -W 1920 -H 1080 -r 60 -o 30 -f -F fsr --sharpness 10 --expose-wayland -- ";

    # Games
    steam-silent="${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh steam -nochatui -nofriendsui -silent";
    gamescope_run="/bin/gamescope -w 1477 -h 831 -W 1920 -H 1080 -r 60 -o 30 -f -F fsr --sharpness 10 --expose-wayland --";
    winejp="LC_ALL=ja_JP.UTF-8 TZ=Asia/Tokyo WINEPREFIX=${config.home.homeDirectory}/Games/Unlocked/_winejp/ WINEARCH=win32 wine";
    nw="${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh env LD_PRELOAD=${config.xdg.userDirs.documents}/Private/Linux/bin/nwjs-latest-linux-x64/libffmpeg.so ${config.xdg.userDirs.documents}/Private/Linux/bin/nwjs-latest-linux-x64/nw";
    nw72="${config.home.sessionVariables.XDG_BIN_HOME}/conty.sh env LD_PRELOAD=${config.xdg.userDirs.documents}/Private/Linux/bin/nwjs-v0.72.0-linux-x64/libffmpeg.so ${config.xdg.userDirs.documents}/Private/Linux/bin/nwjs-v0.72.0-linux-x64/nw";

  };
}
