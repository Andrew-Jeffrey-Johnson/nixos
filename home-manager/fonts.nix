{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.fonts;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    fonts.enable = lib.mkEnableOption "Adds nerdfonts.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    fonts.fontconfig.enable = true;
    home.packages = [
      # Nerdfonts
      pkgs.nerd-fonts
      pkgs.font-awesome
      pkgs.dejavu_fonts
      pkgs.font-awesome
    ];
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
