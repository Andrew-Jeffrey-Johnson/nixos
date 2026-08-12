{
  programs.kitty = {
    #enable = true;
    shellIntegration.enableBashIntegration = true;
    enableGitIntegration = true;
    themeFile = "Catppuccin-Latte";
    keybindings = {
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";
    };
  };
}
