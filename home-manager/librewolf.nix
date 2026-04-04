{
  config,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      Cookies = {
        "Allow" = [
          "https://discord.com"
          "https://github.com"
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
        "browser.toolbar.bookmarks.visibility" = "newtab";
        "browser.toolbars.bookmarks.visibility" = "newtab";
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
}
