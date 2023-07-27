{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    # Add other inputs if needed
  };

  outputs = { self, nixpkgs, home-manager, flatpaks }:
  {
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake
    homeConfigurations = {
      "fenglengshun@ostree-pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        modules = [
          ./pc/home.nix
          flatpaks.homeManagerModules.default
        ];
      };
      "fenglengshun@neon-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        modules = [
          ./laptop/home.nix
          flatpaks.homeManagerModules.default
        ];
      };
    };
  };
}
