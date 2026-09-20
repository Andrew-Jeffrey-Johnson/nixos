{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.luminlapid.samba;
in
{
  options.luminlapid = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    samba.enable = lib.mkEnableOption "Enables connection to the SAMA server on luminlapid-server.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ pkgs.cifs-utils ];
    # Secret for nixos login
    age.secrets.samba-sever-nixos = {
      file = ../secrets/samba-server-nixos.age;
      owner = "nixos";
      group = "users";
    };
    fileSystems."/mnt/luminlapid-server-smb" = {
      device = "10.0.0.183:/";
      fsType = "cifs";
      options =
        let
          # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        in
        [ "${automount_opts},credentials=${config.age.secrets.samba-sever-nixos.path}" ];
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
