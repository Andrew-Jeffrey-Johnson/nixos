{
  config,
  lib,
  ...
}:
let
  cfg = config.luminlapid.nfs;
in
{
  options.luminlapid = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    nfs.enable = lib.mkEnableOption "Enables connection to the NFS server on luminlapid-server.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ ];
    fileSystems."/mnt/luminlapid-server-nfs" = {
      device = "10.0.0.183:/";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
      ];
    };
    # optional, but ensures rpc-statsd is running for on demand mounting
    boot.supportedFilesystems = [ "nfs" ];
    networking.hosts = {
      "10.0.0.183" = [ "luminlapid" ];
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
