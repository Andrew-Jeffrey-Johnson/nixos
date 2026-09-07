# ~/nixos/home-manager/programs/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.coreApps;
in
{
  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    coreApps.enable = lib.mkEnableOption "Core packages for basic functionality";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    home.packages = [
      # For AI
      #pkgs.aider-chat
      #pkgs.llama-cpp-rocm
      #pkgs.rocmPackages.rocm-smi
      #pkgs.rocmPackages.tensile
      #pkgs.rocmPackages.rocprim
      #pkgs.rocmPackages.clr
      #pkgs.rocmPackages.rocblas

      #pkgs.xdg-utils
      #pkgs.findutils
      #pkgs.zenity
      #pkgs.websocat
      #pkgs.jq
      #pkgs.nvtopPackages.amd
      pkgs.trash-cli # Command-line trash
      pkgs.duckdb # Stores commands from cli
      pkgs.sqlite # Database as a file
      pkgs.wget # Get web pages
      pkgs.wl-clipboard-rs # Terminal clipboard
      # Compression programs
      pkgs._7zz
      pkgs.unzip
      pkgs.vlc # Media player
      pkgs.mpv # Media player
    ];
    programs = {
      yazi = {
        enable = true;
        settings = {
          yazi = {
            mgr = {
              show_hidden = true;
              ratio = [
                1
                3
                4
              ];
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
          };
        };
      };
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        enableGitIntegration = true;
        themeFile = "Catppuccin-Latte";
        keybindings = {
          "ctrl+shift+t" = "new_tab_with_cwd";
          "ctrl+shift+enter" = "new_window_with_cwd";
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
        enableBashIntegration = true;
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
      zsh = {
        enable = true;
        envExtra = ''
          function y() {
            local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
            command yazi "$@" --cwd-file="$tmp"
            IFS= read -r -d \'\' cwd < "$tmp"
            [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
            command rm -f -- "$tmp"
          }
        '';
        enableCompletion = true;
        autosuggestion.enable = true;
        autocd = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
          ll = "ls -l";
        };
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "powerlevel10k-config";
            src = ./.;
            file = ".p10k.zsh";
          }
        ];
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
      keepassxc = {
        enable = true;
      };
    };

    #environment.pathsToLink = [ "/share/zsh" ];
    home.file.".p10k.zsh".text = builtins.readFile ./.p10k.zsh;

    # To get virt-manager to find vms
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    # Automount disks
    services.udiskie = {
      enable = true;
    };
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };
}
