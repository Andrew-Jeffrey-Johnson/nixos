# ~/nixos/home-manager/programs/default.nix
{
  config,
  lib,
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
    ];
    home.programs = {
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
  };

  meta = {
    # Meta-attributes to provide extra information like documentation or maintainers.
  };

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
}
