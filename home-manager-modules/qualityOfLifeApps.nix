{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.qualityOfLifeApps;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    qualityOfLifeApps.enable = lib.mkEnableOption "Gaming applications and support packages";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    home.packages = [
      pkgs.catppuccin # Many color themes
      pkgs.qalculate-qt # Calculator
      pkgs.qbittorrent # Torret
    ];
    programs = {
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
