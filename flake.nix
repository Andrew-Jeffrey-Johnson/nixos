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
    nix-gaming = {
      url = "github:fufexan/nix-gaming/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ts = {
      url = "github:tree-sitter/tree-sitter/master";
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
      ts,
    }@inputs:
    {
      nixosConfigurations = {
        andrew =
          let
            args = {
              inherit inputs;
              system = "x86_64-linux";
              allowUnfree = true;
              gamesDesired = true;
              discordDesired = true;
              zoom-usDesired = true;
              rarDesired = true;
            };
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = args;
            modules = [
              nixvim.nixosModules.nixvim
              ./desktop-configuration.nix
              ./hardware-configuration.nix
              ./andrew.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useUserPackages = true;
                  useGlobalPkgs = true;
                  extraSpecialArgs = args;
                  users.andrew = import ./andrew-home-manager;
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
