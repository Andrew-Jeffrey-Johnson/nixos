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
    samba.username = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "andrew";
      description = "The username of the user who will run the samab client.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ pkgs.cifs-utils ];
    # Secret for nixos login
    age.secrets.samba-server-nixos = {
      file = ../secrets/samba-server-nixos.age;
      owner = cfg.username;
      group = "users";
    };
    fileSystems."/mnt/luminlapid-public" = {
      device = "//10.0.0.183/public";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        in
        [
          "${automount_opts},credentials=${config.age.secrets.samba-server-nixos.path},uid=${
            toString config.users.users.${cfg.username}.uid
          },gid=${toString config.users.groups.users.gid}"
        ];
    };
    fileSystems."/mnt/luminlapid-private" = {
      device = "//10.0.0.183/private";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        in
        [
          "${automount_opts},credentials=${config.age.secrets.samba-server-nixos.path},uid=${
            toString config.users.users.${cfg.username}.uid
          },gid=${toString config.users.groups.users.gid}"
        ];
    };
    fileSystems."/mnt/luminlapid-jellyfin" = {
      device = "//10.0.0.183/jellyfin";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        in
        [
          "${automount_opts},credentials=${config.age.secrets.samba-server-nixos.path},uid=${
            toString config.users.users.${cfg.username}.uid
          },gid=${toString config.users.groups.users.gid}"
        ];
    };
    fileSystems."/mnt/luminlapid-jellyfin-samsung1TSSD" = {
      device = "//10.0.0.183/jellyfin-samsung1TSSD";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        in
        [
          "${automount_opts},credentials=${config.age.secrets.samba-server-nixos.path},uid=${
            toString config.users.users.${cfg.username}.uid
          },gid=${toString config.users.groups.users.gid}"
        ];
    };
    assertions = [
      {
        assertion = cfg.username != "";
        message = "When using the samba client, you must specify a username under which to run the client.";
      }
    ];
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
