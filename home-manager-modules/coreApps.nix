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
    coreApps.allowUnfree = lib.mkEnableOption "Add optional unfree software";
    coreApps.username = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "andrew";
      description = "The name of your home folder, which is your username.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    xdg.autostart.enable = true; # Necessary to autostart keepassxc
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
      # Compress/ion programs
      pkgs._7zz
      pkgs.unzip
      (lib.mkIf cfg.allowUnfree pkgs.rar)
      pkgs.vlc # Media player
      pkgs.mpv # Media player
      pkgs.jellyfin-desktop # Media streamer and player
      pkgs.pgadmin4 # Server that hosts a website to view PostgreSQL database
      pkgs.signal-desktop
    ];
    programs = {
      git-credential-keepassxc = {
        enable = false; # Maybe in the future
      };
      keepassxc = {
        enable = true;
        settings = {
          General = {
            BackupBeforeSave = true;
            BackupFilePathPattern = "../backups/{DB_FILENAME}.{TIME:yyyy_MM_dd__hh_mm_ss}.kdbx";
            AutoGeneratePasswordForNewEntries = true;
            ConfigVersion = 2;
            MinimizeAfterUnlock = true;
            URLDoubleClickAction = 2;
          };
          Browser = {
            AlwaysAllowAccess = true;
            AlwaysAllowUpdate = true;
            Browser_AllowLocalhostWithPasskeys = true;
            CustomProxyLocation = null;
            Enabled = true;
            HttpAuthPermission = true;
          };
          GUI = {
            AdvancedSettings = true;
            ApplicationTheme = "dark";
            ColorPasswords = true;
            CompactMode = true;
            HidePasswords = true;
            ShowTrayIcon = true;
            LockDatabaseIdle = false;
            HideGroupPanel = false;
            HideMenubar = false;
            HidePreviewPanel = false;
            HideToolbar = false;
            MinimizeOnClose = true;
            MinimizeOnStartup = true;
            MinimizeToTray = true;
            MovableToolbar = true;
            TrayIconAppearance = "colorful";
          };
          PasswordGenerator = {
            AdditionalChars = null;
            AdvancedMode = true;
            Braces = true;
            Dashes = true;
            EASCII = false;
            ExcludedChars = null;
            Length = 64;
            Logograms = true;
            LowerCase = true;
            Math = true;
            Numbers = true;
            Punctuation = true;
            Quotes = true;
            SpecialChars = true;
            UpperCase = true;
          };
          FdoSecrets = {
            Enabled = true;
          };
          SSHAgent = {
            Enabled = true;
          };
          Security = {
            IconDownloadFallback = true;
            LockDatabaseIdle = false;
          };
        };
      };
      yazi = {
        enable = true;
        shellWrapperName = "y";
        settings = {
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
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        enableGitIntegration = true;
        autoThemeFiles = {
          dark = "Catppuccin-Frappe";
          light = "Catppuccin-Latte";
          noPreference = "Catppuccin-Frappe";
        };
        keybindings = {
          "ctrl+shift+t" = "new_tab_with_cwd";
          "ctrl+shift+enter" = "new_window_with_cwd";
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
          function update() {
            pushd /home/${cfg.username}/nixos
            echo "Pulling the latest changes from the git repository."
            if git fetch && git pull ;
            then
              echo "We have the latest changes. Run the command to build a new configuration."
              sudo nixos-rebuild switch --flake /home/${cfg.username}/nixos/#${cfg.username}
            fi
            popd
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
    };

    services.syncthing = {
      enable = true;
      guiCredentials = {
        username = "andrew";
        passwordFile = "/home/andrew/syncthing-password";
      };
      settings = {
        folders."/home/${cfg.username}/syncthing".enable = true; # Default folder for new synced folders
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
