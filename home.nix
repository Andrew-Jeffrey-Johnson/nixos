{ config, pkgs, ... }:

{
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
      pkgs.waybar
      pkgs.calcurse
      pkgs.tmux
      pkgs.termpdfpy

      pkgs.jdk23
      pkgs.libreoffice-fresh
      pkgs.hunspell
      pkgs.hunspellDicts.en_US-large
      pkgs.prismlauncher
      pkgs.lutris
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
      pkgs.kdePackages.korganizer
      pkgs.poppler
      pkgs.kdePackages.marble
      pkgs.ollama-cuda
      pkgs.tabby # Self-hosted AI coding assistant
      pkgs.quarto
      pkgs.mermaid-filter
      pkgs.pandoc
      pkgs.mpv
      (pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-toolsai.jupyter-keymap
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        batisteo.vscode-django
        bierner.markdown-mermaid
        james-yu.latex-workshop
        mkhl.direnv
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-mermaid-editor";
            publisher = "tomoyukim";
            version = "0.19.1";
            #sha256 = "";
            sha256 = "sha256-MZkR9wPTj+TwhQP0kbH4XqlTvQwfkbiZdfzA10Q9z5A=";
          }
          {
            name = "mermaid-markdown-syntax-highlighting";
            publisher = "bpruitt-goddard";
            version = "1.7.0";
            #sha256 = "";
            sha256 = "sha256-Vjmc9tlHSFdhhcSopUG3MnyBSi//B6cpnavqFLhVRho=";
          }
          {
            name = "quarto";
            publisher = "quarto";
            version = "1.118.0";
            #sha256 = "";
            sha256 = "sha256-fQMORF2LJKhkKbinex+c5I+kM5YM93W2XzOL8PMVZS0=";
          }
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            #sha256 = "";
            sha256 = "sha256-LxFOxkcQNCLotgZe2GKc2aGWeP9Ny1BpD1XcTqB85sI=";
          }
          {
            name = "vscode-tabby";
            publisher = "TabbyML";
            version = "1.20.1";
            #sha256 = "";
            sha256 = "sha256-/+l7TRFtO+TKmyBZ3fmbYWcP9QZ4ClHKuwDYaXKF8W8=";
          }
          {
            name = "sqlite-viewer";
            publisher = "qwtel";
            version = "0.10.2";
            #sha256 = "";
            sha256 = "sha256-5TqcxSJPSmLRBhrhVbAd1VdL2kyszezl8sSrlSynOms=";
          }
          {
            name = "latex-workshop";
            publisher = "james-yu";
            version = "10.8.0";
            #sha256 = "";
            sha256 = "sha256-tdQ3Z/OfNH0UgpHcn8Zq5rQxoetD61dossEh8hRygew=";
          }
        ];
      })
  ];

  programs.direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    programs.bash = {
      enable = true;
      initExtra = "eval \"$(direnv hook bash)\"\n"; # hook direnv
    };
    programs.git = {
      enable = true;
      userEmail = "andrew.jeffrey.johnson@gmail.com";
      userName = "Andrew-Jeffrey-Johnson";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    programs.gh = {
      enable = true;
    };
    programs.yazi = {
      enable = true;
      settings.manager = {
        show_hidden = true;
      };
    };
    programs.neovim = { 
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
