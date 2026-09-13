{
  config,
  lib,
  pkgs,
  nixgl,
  ...
}:
let
  cfg = config.nixglSupport;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    nixglSupport.enable = lib.mkEnableOption "Enables gpu-based applications for home-manager applictaions installed on non-NixOS distributions.";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    targets.genericLinux.nixGL = {
      packages = nixgl.packages;
      #defaultWrapper = "mesa";
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
