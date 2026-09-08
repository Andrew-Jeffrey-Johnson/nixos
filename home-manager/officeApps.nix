{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.officeApps;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    officeApps.enable = lib.mkEnableOption "Office applications and support packages";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    home.packages = [
      # Office Programs
      pkgs.libreoffice-fresh # Office suite
      pkgs.hunspell # Spell-checker for libreoffice
      pkgs.hunspellDicts.en_US-large # English dictionary for hunspell

      # LaTeX Editor
      pkgs.texstudio
      pkgs.texliveFull
      pkgs.poppler # PDF viwer used by texstudio

      # Dictionary
      pkgs.goldendict-ng # Multi-language dictionary app
    ];
    programs = {
      thunderbird = {
        enable = true;
        #policies = { };
        #Preferences = { };
        #preferencesStatus = "default";
        # "default": Preferences appear as default.
        # "locked": Preferences appear as default and can’t be changed.
        # "user": Preferences appear as changed.
        # "clear": Value has no effect. Resets to factory defaults on each startup.
      };
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
