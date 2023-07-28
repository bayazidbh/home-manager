{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # use nixpkgs-unstable as main nixpkgs source
    home-manager = {
      url = "github:nix-community/home-manager"; # home-manager unstable url
      inputs.nixpkgs.follows = "nixpkgs"; # inherit nixpkgs-unstable as main nixpkgs source
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable"; # declarative-flatpak, still WIP
    # Add other inputs if needed
  };

  outputs = { self, nixpkgs, home-manager, flatpaks }:
  {
    # Standalone home-manager configuration entrypoint
    homeConfigurations = {
    # declare username@hostname specific configuration
      "fenglengshun@ostree-pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        modules = [
          ./pc/home.nix # device specific home.nix
          flatpaks.homeManagerModules.default # import declarative-flatpak module
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
