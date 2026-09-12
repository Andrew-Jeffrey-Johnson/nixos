{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.localWiki;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    localWiki.enable = lib.mkEnableOption "Creates a wiki running on this device.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    environment.systemPackages = [ ];
    services.mediawiki = {
      enable = true;
      name = "Personal MediaWiki";
      httpd.virtualHost = {
        hostName = "localhost";
        adminAddr = "andrew.jeffrey.johnson@gmail.com";
      };
      # Administrator account username is admin.
      # Set initial password to "cardbotnine" for the account admin.
      passwordFile = pkgs.writeText "password" "cardbotnine";
      extraConfig = ''
        # Disable anonymous editing
        $wgGroupPermissions['*']['edit'] = false;
      '';

      extensions = {
        # some extensions are included and can enabled by passing null
        VisualEditor = null;

        # https://www.mediawiki.org/wiki/Extension:TemplateStyles
        TemplateStyles = pkgs.fetchzip {
          url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_40-5c3234a.tar.gz";
          hash = "sha256-IygCDgwJ+hZ1d39OXuJMrkaxPhVuxSkHy9bWU5NeM/E=";
        };
        SyntaxHighlight = pkgs.fetchzip {
          url = "https://extdist.wmflabs.org/dist/extensions/SyntaxHighlight_GeSHi-REL1_45-15d5b9b.tar.gz";
          hash = "sha256-ghIS1hn0ZQjwXL8Zb+2sjdNwROzdZZpeSnO7xQtKCXo=";
        };
      };
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
