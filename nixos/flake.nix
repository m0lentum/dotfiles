{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # generally avoiding unstable but using it to keep up with some
    # particularly fast-moving programs like nushell
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    # TODO: switch home-manager to 23.05 once it has a release for it
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      buildLinuxSystem = { configPath, homePath }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            configPath
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mole = import homePath;
              home-manager.extraSpecialArgs = inputs // {
                pkgsUnstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        moletable = buildLinuxSystem {
          configPath = ./configuration-moletable.nix;
          homePath = ./home-moletable.nix;
        };
        molelap = buildLinuxSystem {
          configPath = ./configuration-molelap.nix;
          homePath = ./home-molelap.nix;
        };
        molework = buildLinuxSystem {
          configPath = ./configuration-molework.nix;
          homePath = ./home-molework.nix;
        };
      };
    };
}
