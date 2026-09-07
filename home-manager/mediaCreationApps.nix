{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mediaCreationApps;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    mediaCreationApps.enable = lib.mkEnableOption "Gaming applications and support packages";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    home.packages = [
      # OBS recording
      pkgs.obs-studio
      pkgs.obs-do
      pkgs.obs-cmd
      pkgs.obs-cli

      pkgs.blender
      pkgs.gimp # Rastor Image Editor
      pkgs.audacity # Audio Editor
      pkgs.inkscape # Vector Image Editor
    ];
    programs = {
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
