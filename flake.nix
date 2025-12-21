{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      aagl,
      plasma-manager,
      nur,
      ...
    }@inputs:
    let
      hmModules = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.nox = import ./home/nox.nix;
            backupFileExtension = "backup";
            sharedModules = [ plasma-manager.homeModules.plasma-manager ];
          };
        }
      ];
      aaglModule = [
        {
          imports = [ aagl.nixosModules.default ];
          nix.settings = aagl.nixConfig;
          programs.honkers-railway-launcher.enable = true;
        }
      ];
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          hmModules
          ++ aaglModule
          ++ [
            ./machines/nixos.nix
            nur.modules.nixos.default
          ];
      };
      nixosConfigurations.fwdesktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          hmModules
          ++ aaglModule
          ++ [
            ./machines/fwdesktop.nix
            { nixpkgs.config.rocmSupport = true; }
            nur.modules.nixos.default
          ];
      };
    };
}
