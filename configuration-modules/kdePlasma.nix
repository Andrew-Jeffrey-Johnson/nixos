{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.kdePlasma;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    kdePlasma.enable = lib.mkEnableOption "Enables the desktop environment KDE Plasma with Wayland.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ ];
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    boot.initrd.kernelModules = [ "amdgpu" ]; # Video drivers
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    programs.xwayland.enable = true; # Support for X11 apps
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
