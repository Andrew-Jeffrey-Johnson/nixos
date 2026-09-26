{
  config,
  lib,
  ...
}:
let
  cfg = config.luminlapid.networking;
in
{
  options.luminlapid = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    networking.enable = lib.mkEnableOption "Basic internet connection.";
    networking.hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      example = "Andrews-desktop";
      description = "What the system is known as by local and remote networks.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ ];
    networking = {
      nat = {
        enable = true;
        internalInterfaces = [ "ve-+" ]; # ve-+ is a wildcard that matches all container interfaces
        externalInterface = "ens3";
        # Lazy IPv6 connectivity for the container
        enableIPv6 = true;
      };
      hostName = cfg.hostName; # Define your hostname.
      #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # DNS
      nameservers = [
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
      useDHCP = false;
      dhcpcd.enable = false;

      # Enable networking
      networkmanager = {
        enable = true;
        # If you are using Network Manager, you need to explicitly prevent it from managing container interfaces
        unmanaged = [ "interface-name:ve-*" ];
        # Disable NetworkManager's internal DNS resolution. We are using Quad9
        dns = "none";
      };
    };
    assertions = [
      {
        assertion = cfg.hostName != "nixos";
        message = "You must specify a host name. It cannot be nixos.";
      }
    ];
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
