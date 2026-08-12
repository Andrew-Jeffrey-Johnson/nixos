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
      url = "github:nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs"; # Devs don't test on latest
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
        # NOTE: 'nixos' is the default hostname set by the installer
        andrew =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            # NOTE: Change this to aarch64-linux if you are on ARM
            specialArgs = { inherit inputs system; };
            modules = [
              ./desktop-configuration.nix
              ./hardware-configuration.nix
              ./andrew.nix
              ./programs/zsh.nix
              ./programs/yazi.nix
              nixvim.nixosModules.nixvim
              ./programs/nixvim.nix
              ./programs/librewolf.nix
              ./programs/thunderbird.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useUserPackages = true;
                  useGlobalPkgs = true;
                  extraSpecialArgs = { inherit inputs; };
                  users.andrew = import ./andrew-home-manager;
                  backupFileExtension = "backup";
                };
              }
            ];
          };
        avery = nixpkgs.lib.nixosSystem rec {
          # NOTE: Change this to aarch64-linux if you are on ARM
          system = "x86_64-linux";
          specialArgs = { inherit inputs system; };
          modules = [
            ./desktop-configuration.nix
            ./hardware-configuration.nix
            ./avery.nix
          ];
        };
        server = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs system; };
          modules = [
            ./server-configuration.nix
            ./hardware-configuration.nix
          ];
        };
      };
    };
}
