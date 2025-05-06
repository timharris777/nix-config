{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-homebrew,
      home-manager,
      nixpkgs,
    }:
    {
      # nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      #   system = "aarch64-linux";
      #   specialArgs = { inherit inputs; };
      #   modules = [
      #     ./hosts/nixos
      #     # home-manager.nixosModules.home-manager
      #     # {
      #     #   users.users.tommy.home = "/home/tommy";
      #     #   home-manager = {
      #     #     useGlobalPkgs = true;
      #     #     useUserPackages = true;
      #     #     extraSpecialArgs = { inherit inputs pkgs-stable pkgs-unstable; };
      #     #     users.tommy = {
      #     #       imports = [
      #     #         ./modules/home
      #     #         ./hosts/raziel/home.nix
      #     #       ];
      #     #     };
      #     #   };
      #     # }
      #   ];
      # };

      darwinConfigurations."macos" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit self inputs;
        };
        modules = [
          ./macos
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;
              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;
              # User owning the Homebrew prefix
              user = "tim.harris";
              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."tim.harris".imports = [ ./home ];
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
