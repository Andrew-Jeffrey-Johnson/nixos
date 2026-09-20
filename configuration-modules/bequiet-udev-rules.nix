{
  config,
  lib,
  ...
}:
let
  cfg = config.luminlapid.bequiet-udev-rules;
in
{
  options.luminlapid = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    bequiet-udev-rules.enable = lib.mkEnableOption "Adds udev rules to /etc/udev/rules.d so https://iocenter.bequiet.com/ can see the keyboard attached and update the colors.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ ];
    services.udev = {
      enable = true;
      extraRules = ''
        SUBSYSTEM=="usb", ATTR{bInterfaceNumber}=="02", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0001", TAG+="bequiet"
        SUBSYSTEM=="usb", ATTR{bInterfaceNumber}=="02", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0002", TAG+="bequiet"
        SUBSYSTEM=="usb", ATTR{bInterfaceNumber}=="02", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0003", TAG+="bequiet"
        SUBSYSTEM=="usb", ATTR{bInterfaceNumber}=="02", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0005", TAG+="bequiet"
        SUBSYSTEM=="usb", ATTR{bInterfaceNumber}=="02", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0007", TAG+="bequiet"
        SUBSYSTEM=="usb", ATTR{bInterfaceNumber}=="02", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0018", TAG+="bequiet"
        SUBSYSTEM=="usb", ATTR{bInterfaceNumber}=="02", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0027", TAG+="bequiet"
        SUBSYSTEM=="usb", ATTR{bInterfaceNumber}=="02", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0028", TAG+="bequiet"
        SUBSYSTEM=="hid", ATTR{bInterfaceNumber}=="02", TAGS=="bequiet", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAGS=="bequiet", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0009", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="000a", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0010", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0011", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0016", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0017", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0023", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0024", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0025", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0026", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373f", ATTRS{idProduct}=="0029", MODE="0660", TAG+="uaccess", TAG+="udev-acl", TAG+="bequiet"
      '';
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
