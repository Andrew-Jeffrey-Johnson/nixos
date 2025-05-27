{ config, pkgs, ... }: 
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "main";
  });
  utfCli = pkgs.callPackage ./utf-cli.nix { inherit pkgs; };
in {
  imports = [
    nixvim.homeManagerModules.nixvim
    ./nixvim.nix
    ./hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "andrewj";
  home.homeDirectory = "/home/andrewj";
  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Preparation for Hyprland
      pkgs.wofi
      pkgs.calcurse
      pkgs.tmux
      pkgs.termpdfpy
      pkgs.wget
      pkgs.nix-index
      pkgs.manix
      utfCli
      pkgs.wl-clipboard
      pkgs.catppuccin
      pkgs.wordbook
      pkgs.epy

      pkgs.jdk23
      pkgs.libreoffice-fresh
      pkgs.hunspell
      pkgs.hunspellDicts.en_US-large
      pkgs.prismlauncher
      pkgs.qalculate-qt
      pkgs.qbittorrent
      pkgs.chromium
      pkgs.librewolf
      pkgs.gimp
      pkgs.audacity
      pkgs.inkscape
      pkgs.texstudio
      pkgs.texlive.combined.scheme-full
      pkgs.vlc
      pkgs.poppler
      pkgs.quarto
      pkgs.mermaid-filter
      pkgs.pandoc
      pkgs.mpv
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      initExtra = "eval \"$(direnv hook bash)\"\n"; # hook direnv
    };
    git = {
      enable = true;
      userEmail = "andrew.jeffrey.johnson@gmail.com";
      userName = "Andrew-Jeffrey-Johnson";
      extraConfig = {
        init.defaultBranch = "main";
        core.excludesFile = "~/.gitignore";
      };
      signing = {
        signByDefault = true;
        key = "ED4D0E25B7FBFAEA62DE63BD71576CF0B1AF61F6";
      };
    };
    gh = {
      enable = true;
    };
    yazi = {
      enable = true;
      settings = {
        manager = {
          show_hidden = true;
          ratio = [1 3 4];
        };
        opener = {
          openBook = [
            { run = pkgs.epy + /bin/epy + " \"$@\""; block = true; }
          ];
        };
        open = {
          prepend_rules = [
            { name = "*.epub"; use = "openBook"; }
          ];
        };
      };
    };
    nixvim = {
      enable = true;
      defaultEditor = true;
      colorschemes.catppuccin.enable = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;
    };
    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      enableGitIntegration = true;
      themeFile = "Catppuccin-Latte";
    };
    waybar = {
      enable = true;
      systemd.enable = true;
    };
  };

  services.udiskie = {
    enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".gitignore".text = ''
      
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/andrewj/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    LANG = "en_US.UTF-8";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
