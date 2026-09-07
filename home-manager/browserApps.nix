{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.browseApps;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    browseApps.enable = lib.mkEnableOption "Internet browsers and applications to support them";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    home.packages = [
      pkgs.tor-browser
      pkgs.chromium # Open-source portion of chrome
    ];
    programs = {
      firefox = {
        enable = true;
        package = pkgs.librewolf;
        policies = {
          Cookies = {
            "Allow" = [
              "https://discord.com"
              "https://github.com"
              "https://youtube.com"
            ];
            "Locked" = true;
          };
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          # Go to "about:memory" in FireFox, click measure. It will do a memory report.
          # The memory report will show the id of all currently-installed extensions.
          # Emphemerally install the desired extension. Measure memory. Find id in report.
          ExtensionSettings = {
            # keepassxc-browser
            "keepassxc-browser@keepassxc.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
              installation_mode = "force_installed";
            };
            # uBlock Origin
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
          };
          FirefoxHome = {
            "Search" = false;
          };
          HardwareAcceleration = true;
          Preferences = {
            "browser.preferences.defaultPerformanceSettings.enabled" = false;
            "browser.startup.homepage" = "about:home";
            "browser.toolbar.bookmarks.visibility" = "never";
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.urlbar.suggest.bookmark" = false;
            "browser.urlbar.suggest.engines" = false;
            "browser.urlbar.suggest.history" = false;
            "browser.urlbar.suggest.openpage" = false;
            "browser.urlbar.suggest.recentsearches" = false;
            "browser.urlbar.suggest.topsites" = false;
            "browser.warnOnQuit" = false;
            "browser.warnOnQuitShortcut" = false;
            "places.history.enabled" = "false";
            "privacy.resistFingerprinting" = true;
            "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
          };
        };
      };
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
