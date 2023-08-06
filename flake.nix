{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # use nixpkgs-unstable as main nixpkgs source
    home-manager = {
      url = "github:nix-community/home-manager"; # home-manager unstable url
      inputs.nixpkgs.follows = "nixpkgs"; # inherit nixpkgs-unstable as main nixpkgs source
    };
    };

  outputs = { self, nixpkgs, home-manager }:
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
        ];
      };
      "fenglengshun@neon-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        modules = [
          ./home.nix # default home.nix
          ./default/shell.nix # shell config for all devices
          ./default/env.nix # env-var for all devices
          ./default/alias.nix # aliases for all devices
          ./default/files.nix # file creation for all devices
          ./laptop/by-device.nix # device specific configs
        ];
      };
    };
  };
}
