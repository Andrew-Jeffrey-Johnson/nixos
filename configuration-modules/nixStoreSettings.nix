{
  config,
  lib,
  ...
}:
let
  cfg = config.luminlapid.nixStoreSettings;
in
{
  options.luminlapid = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    nixStoreSettings.enable = lib.mkEnableOption "Basic settings for managing nix store entires.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ ];
    nix = {
      # Automatic garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        download-buffer-size = 500000000; # 500 MB
        # Automatically optimize store every build
        auto-optimise-store = true;
        # Enable nix flakes
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
