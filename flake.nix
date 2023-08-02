{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # use nixpkgs-unstable as main nixpkgs source
    home-manager = {
      url = "github:nix-community/home-manager"; # home-manager unstable url
      inputs.nixpkgs.follows = "nixpkgs"; # inherit nixpkgs-unstable as main nixpkgs source
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable"; # declarative-flatpak, still WIP
    nixgl.url = "github:guibou/nixGL"; # nixGL for running Wine
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # https://github.com/chaotic-cx/nyx#how-to-use-it}
    # Add other inputs if needed
  };

  outputs = { self, nixpkgs, home-manager, flatpaks, nixgl, chaotic }:
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
      "fenglengshun@ostree-pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        # extraSpecialArgs = { inherit chaotic; inherit nixgl; }; # so that home-manager can correctly read chaotic.packages
        modules = [
          ./home.nix # default home.nix
          ./default/shell.nix # shell config for all devices
          ./default/env.nix # env-var for all devices
          ./default/alias.nix # aliases for all devices
          ./default/files.nix # file creation for all devices
          ./pc/by-device.nix # device specific configs
          ./pc/flatpak.nix # separate list for flatpak
          ./pc/chaotic.nix # separate list for chaotic.nix packages
          flatpaks.homeManagerModules.default # declarative-flatpak HM module
          chaotic.homeManagerModules.default # chaotic nyx HM module
        ];
      };
      "fenglengshun@neon-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit nixgl; }; # so that home-manager can correctly read chaotic.packages
        modules = [
          ./home.nix # default home.nix
          ./default/shell.nix # shell config for all devices
          ./default/env.nix # env-var for all devices
          ./default/alias.nix # aliases for all devices
          ./default/files.nix # file creation for all devices
          ./laptop/by-device.nix # device specific configs
          ./laptop/flatpak.nix # separate list for flatpak
          ./laptop/chaotic.nix # separate list for chaotic.nix package
          ./laptop/nixgl.nix # separate list for nixgl.nix package
          flatpaks.homeManagerModules.default # import declarative-flatpak module
          chaotic.homeManagerModules.default # chaotic nyx HM module
        ];
      };
    };
  };
}
