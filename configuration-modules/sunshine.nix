{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sunshine;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    sunshine.enable = lib.mkEnableOption "Enables Sunshine to start on system start. For moonlight.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ ];
    # Sunshine is the remote desktop for Moonshine
    services.sunshine = {
      enable = true;
      autoStart = true; # optional: starts Sunshine automatically on login
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
