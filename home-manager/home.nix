{
  #config,
  pkgs,
  lib,
  nixvim,
  nur-no-pkgs,
  ...
}:
#let
# nixvim = import (
#   builtins.fetchGit {
#     url = "https://github.com/nix-community/nixvim";
#     ref = "main";
#   }
# );
#nak = pkgs.stdenv.mkDerivation {
#  name = "SulfurNitride";
#  src = builtins.fetchTarball {
#    url = "https://github.com/SulfurNitride/NaK/archive/refs/tags/4.4.1.tar.gz";
#    hash = "ssha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
#  };
#};
# nur-no-pkgs =
#   import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz")
#     { };
#utfCli = pkgs.callPackage ./utf-cli.nix;
#in
{
  imports = [
    #nixvim.homeModules.nixvim
    ./nixvim.nix
    #./hyprland.nix
    #./lsp.nix
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "andrew";
  home.homeDirectory = "/home/andrew";

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
    #pkgs.termpdfpy
    pkgs.wget
    pkgs.nix-index
    pkgs.manix
    #utfCli
    pkgs.wl-clipboard
    pkgs.catppuccin
    pkgs.wordbook
    pkgs.epy
    pkgs.trash-cli
    pkgs.kiwix
    pkgs.duckdb
    pkgs.sqlite
    pkgs.gamescope # For steam games
    pkgs.wf-recorder

    # For nixvim
    #pkgs.alejandra
    pkgs.gcc # For Neorg
    pkgs.python313Packages.flake8

    pkgs.jdk25
    pkgs.libreoffice-fresh
    pkgs.hunspell
    pkgs.hunspellDicts.en_US-large
    pkgs.prismlauncher
    pkgs.qalculate-qt
    pkgs.qbittorrent
    pkgs.chromium
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
    pkgs.sshfs
    pkgs.prevo-tools
    pkgs.prevo-data
    pkgs.kdePackages.ksystemlog
    pkgs.pgadmin4

    # For Lutris games
    pkgs.winetricks
    #pkgs.wine
    pkgs.protonplus
    pkgs.wineWow64Packages.stable
    #pkgs.wine64Packages.stableFull
    #pkgs.wineWow64Packages.unstableFull
    pkgs.protontricks
    pkgs.lutris
    pkgs.xdg-utils
    pkgs.findutils

    pkgs.tor-browser
    pkgs.youtube-tui
  ];

  programs = {
    inherit nixvim;
    librewolf = {
      enable = true;
      # Enable WebGL, cookies and history
      settings = {
        "webgl.disabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
      profiles.default = {
        isDefault = true;
        name = "default";
        bookmarks = {
          force = true;
          settings = [
            {
              toolbar = true;
              bookmarks = [
                {
                  name = "YaCy";
                  url = "http://localhost:8090";
                }
                {
                  name = "Open WebUI";
                  url = "http://localhost:8080";
                }
                {
                  name = "NixOS Search";
                  url = "https://search.nixos.org";
                }
              ];
            }
          ];
        };
        extensions = {
          packages = with nur-no-pkgs.repos.rycee.firefox-addons; [
            noscript
            keepassxc-browser
          ];
        };
      };
    };
    sftpman = {
      enable = true;
      mounts = {
        luminlapid = {
          authType = "publickey";
          host = "10.0.0.183";
          port = 22;
          user = "nixos";
          mountPoint = "/";
          sshKey = "/home/andrewj/.ssh/id_ed25519";
        };
      };
    };
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
      settings = {
        user.email = "andrew.jeffrey.johnson@gmail.com";
        user.name = "Andrew-Jeffrey-Johnson";
        init.defaultBranch = "main";
        core.excludesFile = "~/.gitignore";
      };
      signing = {
        signByDefault = true;
      };
      settings = {
        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
      };
    };
    gh = {
      enable = true;
    };
    /*
      waybar = {
        enable = true;
        systemd.enable = true;
        settings.main = {
          modules-left = [
            "cpu"
            "hyprland/workspaces"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "tray"
            "network"
            "pulseaudio"
          ];
          "clock" = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "{:%I:%M %p}";
          };
            #"network" = {
            #  interface = "*";
            #  format = "{ifname}";
            #  format-wifi = "{essid} ({signalStrength}%) ";
            #  format-ethernet = "{ipaddr}/{cidr} 󰊗";
            #  format-disconnected = ""; # An empty format will hide the module.
            #  tooltip-format = "{ifname} via {gwaddr} 󰊗";
            #  tooltip-format-wifi = "{essid} ({signalStrength}%) ";
            #  tooltip-format-ethernet = "{ifname} ";
            #  tooltip-format-disconnected = "Disconnected";
            #  max-length = 50;
            #};
        };
      };
    */
    yazi = {
      enable = true;
      settings = {
        mgr = {
          show_hidden = true;
          ratio = [
            1
            3
            4
          ];
        };
        opener = {
          play = [
            {
              run = "mpv %s";
              orphan = true;
            }
          ];
          edit = [
            {
              run = "$EDITOR %s";
              block = true;
            }
          ];
          openBook = [
            {
              run = pkgs.epy + /bin/epy + " \"$@\"";
              block = true;
            }
          ];
        };
        open = {
          rules = [
            {
              mime = "text/*";
              use = "edit";
            }
            {
              mime = "video/*";
              use = "play";
            }
            {
              name = "*.epub";
              use = "openBook";
            }
            {
              url = "*";
              use = "librewolf";
            }
          ];
        };
      };
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = "u";
              run = "plugin restore";
              desc = "Restore last deleted files/folders";
            }
            # ... Other keymaps
          ];
        };
      };
      plugins = {
        restore = pkgs.yaziPlugins.restore;
        duckdb = pkgs.yaziPlugins.duckdb;
      };
    };
    keepassxc = {
      enable = true;
    };
    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      enableGitIntegration = true;
      themeFile = "Catppuccin-Latte";
    };
    eww = {
      enable = true;
      configDir = ./eww;
      enableBashIntegration = true;
    };
  };

  # To get virt-manager to find vms
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
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
      debug.txt
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
