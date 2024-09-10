{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # use nixpkgs-unstable as main nixpkgs source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # use nixos stable 23.11 as main nixpkgs source
    home-manager = {
      # url = "github:nix-community/home-manager/master"; # home-manager unstable url
      url = "github:nix-community/home-manager/release-24.05"; # home-manager stable url
      inputs.nixpkgs.follows = "nixpkgs"; # inherit nixpkgs-unstable as main nixpkgs source
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3"; # declarative-flatpak new stable
    nixgl.url = "github:guibou/nixGL"; # nixGL for running Wine
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # https://github.com/chaotic-cx/nyx#how-to-use-it
    # Add other inputs if needed
  };

  outputs = { self, nixpkgs, home-manager, flatpaks, nixgl }:
  # nixpkgs-unstable chaotic
  let

    # System types to support.  [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    supportedSystems = [ "x86_64-linux" ];
    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    # Nixpkgs instantiated for supported system types.
    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

  in
  {
    # Standalone home-manager configuration entrypoint
    homeConfigurations = {
    # declare a "username" or "username@hostname" specific configuration
      "fenglengshun@bbh-pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit nixgl; }; # so that home-manager can correctly read nixgl packages
        modules = [
          flatpaks.homeManagerModules.default # declarative-flatpak HM module
          ./home.nix # pkgs and options for all devices
          ./default/alias.nix # aliases for all devices
          ./default/shell.nix # shell config for all devices
          ./default/autostart.nix # autostart with systemctl
          ./default/env.nix # env-var for all devices
          ./default/files.nix # file creation for all devices
          ./pc/home.nix # device specific packages
          ./pc/env.nix # device specific env-var
          ./pc/files.nix # device specific file creation
          ./pc/autostart.nix # device specific autostart
          ./pc/flatpaks.nix # separate list for flatpak
          ./pc/nixgl.nix # separate list for nixgl.nix package
          # ./pc/chaotic.nix # separate list for chaotic.nix package
          # chaotic.homeManagerModules.default # chaotic nyx HM module
        ];
      };
      "fenglengshun@bbh-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit nixgl; }; # so that home-manager can correctly read nixgl packages
        modules = [
          flatpaks.homeManagerModules.default # declarative-flatpak HM module
          ./home.nix # pkgs and options for all devices
          ./default/alias.nix # aliases for all devices
          ./default/shell.nix # shell config for all devices
          ./default/autostart.nix # autostart with systemctl
          ./default/env.nix # env-var for all devices
          ./default/files.nix # file creation for all devices
          ./laptop/home.nix # device specific packages
          ./laptop/env.nix # device specific env-var
          ./laptop/files.nix # device specific file creation
          ./laptop/autostart.nix # device specific autostart
          ./laptop/flatpaks.nix # separate list for flatpak
          ./laptop/nixgl.nix # separate list for nixgl.nix package
        ];
      };
      "fenglengshun@bbh-lte" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit nixgl; }; # so that home-manager can correctly read nixgl packages
        modules = [
          flatpaks.homeManagerModules.default # declarative-flatpak HM module
          ./home.nix # pkgs and options for all devices
          ./default/alias.nix # aliases for all devices
          ./default/shell.nix # shell config for all devices
          ./default/autostart.nix # autostart with systemctl
          ./default/env.nix # env-var for all devices
          ./default/files.nix # file creation for all devices
          ./laptop/home.nix # device specific packages
          ./laptop/env.nix # device specific env-var
          ./laptop/files.nix # device specific file creation
          ./laptop/autostart.nix # device specific autostart
          ./laptop/flatpaks.nix # separate list for flatpak
          ./laptop/nixgl.nix # separate list for nixgl.nix package
        ];
      };
      "fenglengshun@bbh-server" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        modules = [
          ./server/home.nix # default home.nix
          ./default/shell.nix # shell config for all devices
          ./default/alias.nix # aliases for all devices
        ];
      };
      "root" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        modules = [
          ./root/home.nix # default home.nix
          ./default/shell.nix # shell config for all devices
          ./default/alias.nix # aliases for all devices
        ];
      };
    };
  };
}
