# ~/nixos/flake.nix
{
  description = "NixOS System Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs"; # Devs don't test on latest
    };
    #libtexprintf = {
    #  url = "github:bartp5/libtexprintf";
    #  flake = false;
    #};
    nix-gaming = {
      url = "github:fufexan/nix-gaming/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      # For Secrets
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      nix-gaming,
      agenix,
      nixgl,
    }@inputs:
    {
      nixosConfigurations = {
        andrew =
          let
            system = "x86_64-linux";
            username = "andrew";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit system inputs username;
            };
            modules = [
              #nixvim.nixosModules.nixvim
              agenix.nixosModules.default
              ./configuration-modules
              ./andrew-configuration.nix
              ./andrew-hardware-configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useUserPackages = true; # Only allow home.packages
                  useGlobalPkgs = true;
                  extraSpecialArgs = {
                    inherit system inputs username;
                  };
                  sharedModules = [
                    nixvim.homeModules.nixvim
                    agenix.homeManagerModules.default
                    ./home-manager-modules
                  ];
                  users = {
                    andrew = ./andrew-home-manager.nix;
                  };
                  backupFileExtension = "backup";
                };
              }
            ];
          };
        ave =
          let
            system = "x86_64-linux";
            username = "ave";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit system username inputs;
            };
            modules = [
              #nixvim.nixosModules.nixvim
              agenix.nixosModules.default
              ./configuration-modules
              ./ave-configuration.nix
              ./ave-hardware-configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useUserPackages = true; # Only allow home.packages
                  useGlobalPkgs = true;
                  extraSpecialArgs = {
                    inherit system inputs username;
                  };
                  sharedModules = [
                    nixvim.homeModules.nixvim
                    agenix.homeManagerModules.default
                    ./home-manager-modules
                  ];
                  users = {
                    ave = ./ave-home-manager.nix;
                  };
                  backupFileExtension = "backup";
                };
              }
            ];
          };
        server =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system; };
            modules = [
              agenix.nixosModules.default
              ./configuration-modules
              ./server-configuration.nix
              ./server-hardware-configuration.nix
            ];
          };
      };
    };
}
