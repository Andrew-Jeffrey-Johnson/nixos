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
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      nix-gaming,
      #libtexprintf,
    }@inputs:
    {
      nixosConfigurations = {
        andrew =
          let
            args = {
              inherit inputs;
              system = "x86_64-linux";
              andrewEnabled = true;
              aveEnabled = false;
              allowUnfree = true;
              gamesDesired = true;
              zoom-usDesired = true;
              rarDesired = true;
              lutrisDesired = true;
              steamDesired = true;
            };
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = args;
            modules = [
              nixvim.homeModules.nixvim
              ./desktop-configuration.nix
              ./hardware-configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useUserPackages = false; # Only allow home.packages
                  useGlobalPkgs = true;
                  extraSpecialArgs = args;
                  users = {
                    andrew = ./home-manager/andrew.nix;
                  };
                  backupFileExtension = "backup";
                };
              }
            ];
          };
        avery =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system; };
            modules = [
              ./desktop-configuration.nix
              ./hardware-configuration.nix
              ./avery.nix
            ];
          };
        server =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system; };
            modules = [
              ./server-configuration.nix
              ./hardware-configuration.nix
            ];
          };
      };
    };
}
