{ config, pkgs, ... }:
{
  home.file."resilio.conf" = {
    enable = true;
    target = ".config/rslsync/rslsync.conf.test";
    text = ''
      {
       "device_name": "${config.home.sessionVariables.HOST}",
       "storage_path" : "${config.xdg.configHome}/rslsync",
       "pid_file" : "${config.xdg.configHome}/rslsync/resilio.pid",
       "use_upnp" : true,
       "download_limit" : 0,
       "upload_limit" : 0,
       "directory_root" : "/home",
       "webui" :
       {
       "listen" : "0.0.0.0:8888"
       }
      }
    '';
  };

  home.file."restart-plasma" = {
    enable = true;
    target = ".local/bin/restart-plasma";
    executable = true;
    text = ''
    #! /bin/bash
    killall plasmashell &
    kwin --replace &
    kstart plasmashell &
    disown
    exit
    '';
  };

  home.file."no-root-virt-manager" = {
    enable = true;
    target = ".local/bin/no-root-virt-manager";
    executable = true;
    text = ''
      cat ${config.home.homeDirectory}/.local/bin/no-root-virt-manager
      sudo usermod -a -G kvm ${config.home.username}
      sudo usermod -a -G libvirt ${config.home.username}
      sudo ln -s /etc/apparmor.d/usr.sbin.libvirtd /etc/apparmor.d/disable/
      sudo sed -i "s/\/usr\/libexec\/libvirt_leaseshelper m,/\/usr\/libexec\/libvirt_leaseshelper mr,/g" /etc/apparmor.d/usr.sbin.dnsmasq
      # sudo systemctl restart libvirtd
    '';
  };

  home.file."libvirt.conf" = {
    enable = true;
    target = ".config/libvirt/libvirt.conf";
    text = ''
      uri_default = "qemu:///system"
    '';
  };

  #  home.activation = {
  #    getNonSteamLaunchersInstaller = {
  #      after = [ "writeBoundary" "createXdgUserDirectories" ];
  #      before = [ ];
  #      data = "url=$(/usr/bin/curl -s \"https://api.github.com/repos/moraroy/NonSteamLaunchers-On-Steam-Deck/releases/latest\" | /usr/bin/jq -r '.assets[] | select(.name == \"NonSteamLaunchers.desktop\") | .browser_download_url') && ${config.home.homeDirectory}/.nix-profile/bin/aria2c -c -o .local/share/applications/NonSteamLaunchers.desktop \"$url\"";
  #    };
  #  };

  xdg.desktopEntries."virt-manager-win11" = {
      name = "Windows 11 (VM)";
      icon = "virt-manager";
      exec = "env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /usr/bin/virt-manager --connect";
      comment = "win11 VM on Virt-Manager";
      categories = [ "System" ];
      terminal = false;
      type = "Application";
      settings = {
        Keywords = "vmm;win11;windows;";
      };
    };

}
