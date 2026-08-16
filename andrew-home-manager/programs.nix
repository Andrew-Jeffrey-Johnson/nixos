# ~/nixos/home-manager/programs/default.nix
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
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
  programs = {
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
