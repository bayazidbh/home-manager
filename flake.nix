{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # use nixpkgs-unstable as main nixpkgs source
    home-manager = {
      url = "github:nix-community/home-manager"; # home-manager unstable url
      inputs.nixpkgs.follows = "nixpkgs"; # inherit nixpkgs-unstable as main nixpkgs source
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable"; # declarative-flatpak, still WIP
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # https://github.com/chaotic-cx/nyx#how-to-use-it}
    # Add other inputs if needed
  };

  outputs = { self, nixpkgs, home-manager, flatpaks, chaotic }:
  let
    # Generate a user-friendly version number.
    # version = builtins.substring 0 2 self.lastModifiedDate;

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
        extraSpecialArgs = { inherit chaotic; }; # so that home-manager can correctly read chaotic.packages
        modules = [
          ./pc/home.nix # device specific home.nix
          ./pc/chaotic.nix # separate list for chaotic.nix packages
          flatpaks.homeManagerModules.default # import declarative-flatpak module
          # chaotic.nixosModules.default # default chaotic nyx module
        ];
      };
      "fenglengshun@neon-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        modules = [
          ./laptop/home.nix # device specific home.nix
          flatpaks.homeManagerModules.default # import declarative-flatpak module
        ];
      };
    };
  };
}
