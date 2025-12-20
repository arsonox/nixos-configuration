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
    #lmstudio = {
    #  url = "github:tomsch/lmstudio-nix";
    #};
    #r8126-driver = {
    #  url = "github:arsonox/r8126-driver-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, home-manager, aagl, plasma-manager, nur, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./machines/nixos.nix
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
        {
          imports = [ aagl.nixosModules.default ];
          nix.settings = aagl.nixConfig;
          programs.honkers-railway-launcher.enable = true;
        }
      ];
    };
    nixosConfigurations.fwdesktop = nixpkgs.lib.nixosSystem {
      system = "x86_64";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./machines/fwdesktop.nix
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
        {
          imports = [ aagl.nixosModules.default ];
          nix.settings = aagl.nixConfig;
          programs.honkers-railway-launcher.enable = true;
        }
        nur.modules.nixos.default
        #inputs.r8126-driver.nixosModules.r8126
        #{
        #  boot.kernelModules = [ "r8126" ];
        #  boot.initrd.availableKernelModules = [ "r8126" ];
        #}
      ];
    };
  };
}
