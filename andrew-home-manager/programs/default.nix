# ~/nixos/home-manager/programs/default.nix
{
  pkgs,
  inputs,
  ...
}:
let
  mo2 = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.mo2installer; # installs a package
  tree-sitter = inputs.ts.packages.${pkgs.stdenv.hostPlatform.system}.cli;
in
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    mo2

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
    tree-sitter
    pkgs.ripgrep
    pkgs.fd
    pkgs.lazygit
    pkgs.shfmt
    pkgs.hadolint

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
    pkgs.zenity
    pkgs.websocat
    pkgs.jq
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
