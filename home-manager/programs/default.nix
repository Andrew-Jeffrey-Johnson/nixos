# ~/nixos/home-manager/programs/default.nix
{
  pkgs,
  inputs,
  ...
}:
let
  neovimconfig = import ./../nixvim.nix;
  nvim = inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
  };
  mo2 = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.mo2installer; # installs a package
  tree-sitter = inputs.ts.packages.${pkgs.stdenv.hostPlatform.system}.cli;
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
    pkgs.blender
    pkgs.obs-studio
    pkgs.obs-do
    pkgs.obs-cmd
    pkgs.obs-cli

    # For nixvim
    #pkgs.alejandra
    pkgs.gcc # For Neorg
    pkgs.python314Packages.flake8
    pkgs.vimPlugins.flake8-vim
    pkgs.python314Packages.pylatexenc
    pkgs.ghostscript
    pkgs.sqlite
    pkgs.shellcheck
    pkgs.isort
    pkgs.mermaid-cli
    tree-sitter
    pkgs.ripgrep
    pkgs.fd
    pkgs.lazygit
    pkgs.shfmt
    pkgs.hadolint

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

    # For AI
    pkgs.aider-chat
    pkgs.llama-cpp-rocm
    pkgs.rocmPackages.rocm-smi
    pkgs.rocmPackages.tensile
    pkgs.rocmPackages.rocprim
    pkgs.rocmPackages.clr
    pkgs.rocmPackages.rocblas

    # For Lutris games
    pkgs.winetricks
    pkgs.bottles
    pkgs.protonplus
    pkgs.wineWow64Packages.full
    pkgs.wineWow64Packages.fonts
    pkgs.nvtopPackages.amd
    pkgs.lutris
    pkgs.xdg-utils
    pkgs.findutils
    pkgs._7zz
    pkgs.rar
    pkgs.zenity
    pkgs.websocat
    pkgs.jq
    pkgs.unzip

    pkgs.tor-browser
    pkgs.freetube
    pkgs.discord
    pkgs.calibre
  ];
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
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
      lfs.enable = true;
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
        "ctrl+shift+enter" = "new_window_with_cwd";
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
