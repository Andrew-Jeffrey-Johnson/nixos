# ~/nixos/home-manager/programs/default.nix
{
  pkgs,
  inputs,
  ...
}:
let
  neovimconfig = import ../nixvim;
  nvim = inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
  };
  mo2 = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.mo2installer; # installs a package
in
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    nvim
    mo2

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
    pkgs.bibletime

    # For Lutris games
    pkgs.winetricks
    pkgs.bottles
    #pkgs.wine
    pkgs.protonplus
    pkgs.wineWow64Packages.full
    pkgs.wineWow64Packages.fonts
    #pkgs.wine64Packages.stableFull
    #pkgs.wineWow64Packages.unstableFull
    pkgs.lutris
    pkgs.xdg-utils
    pkgs.findutils
    pkgs._7zz
    pkgs.rar
    pkgs.zenity
    pkgs.websocat
    pkgs.jq

    pkgs.tor-browser
    pkgs.youtube-tui
    pkgs.freetube
  ];
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # librewolf = {
    #   enable = true;
    #   # Enable WebGL, cookies and history
    #   settings = {
    #     "webgl.disabled" = true;
    #     "privacy.clearOnShutdown.history" = false;
    #     "privacy.clearOnShutdown.cookies" = false;
    #     "network.cookie.lifetimePolicy" = 0;
    #   };
    #   profiles.default = {
    #     isDefault = true;
    #     name = "default";
    #     bookmarks = {
    #       force = true;
    #       settings = [
    #         {
    #           toolbar = true;
    #           bookmarks = [
    #             {
    #               name = "YaCy";
    #               url = "http://localhost:8090";
    #             }
    #             {
    #               name = "Open WebUI";
    #               url = "http://localhost:8080";
    #             }
    #             {
    #               name = "NixOS Search";
    #               url = "https://search.nixos.org";
    #             }
    #           ];
    #         }
    #       ];
    #     };
    #     # extensions = {
    #     #   packages = with nur-no-pkgs.repos.rycee.firefox-addons; [
    #     #     noscript
    #     #     keepassxc-browser
    #     #   ];
    #     # };
    #   };
    # };
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
      bashrcExtra = ''
        function y() {
         local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
         command yazi "$@" --cwd-file="$tmp"
         IFS= read -r -d ''' cwd < "$tmp"
         [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
         rm -f -- "$tmp"
        }
      '';
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
        format = null;
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
      shellWrapperName = "y";
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
      keybindings = {
        "ctrl+shift+t" = "new_tab_with_cwd";
      };
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
}
