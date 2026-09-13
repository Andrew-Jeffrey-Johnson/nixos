{
  config,
  lib,
  ...
}:
let
  cfg = config.luminlapid.virtualization;
in
{
  options.luminlapid = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    virtualization.enable = lib.mkEnableOption "Adds several viritualization programs such as docker and QEMU.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ ];
    # Install docker rootless
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    # Install waydroid for running Android apps in containers
    virtualisation.waydroid.enable = true;

    # Emulation and virtualization
    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true; # enable copy and paste between host and guest
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
