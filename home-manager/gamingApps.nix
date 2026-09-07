{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gamingApps;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    gamingApps.enable = lib.mkEnableOption "Gaming applications and support packages";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    home.packages = [
      pkgs.discord
      pkgs.luanti
    ];
    home.programs = {
      lutris = {
        enable = true;
      };
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
