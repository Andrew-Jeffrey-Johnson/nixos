# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Apply changes via:
# sudo nixos-rebuild switch --upgrade
{
  pkgs,
  lib,
  ...
}:
{
  users.users = {
    andrew = {
      enable = true;
      name = "andrew";
      isNormalUser = true;
      description = "Andrew Johnson";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "docker"
        "libvirtd"
        "adbusers"
        "fuse"
      ];
      shell = pkgs.zsh;
    };
  };

  programs.zsh.enable = true; # Required to change default shell
  steam.enable = true;
  bluetooth.enable = true;
  virtualization.enable = true;
  networkingSettings = {
    enable = true;
    hostName = "Andrews-desktop";
  };
  localWiki.enable = true;
  localPostgreSQL.enable = true;
  services.printing.enable = true; # Enable CUPS to print documents.
  sunshine.enable = true;
  nixStoreSettings.enable = true;
  internationalization.enable = true;
  pipewire.enable = true;
  kdePlasma.enable = true;

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    systemd-boot = {
      enable = true;
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/boot" = {
    options = [
      "uid=0"
      "gid=0"
      "fmask=0077"
      "dmask=0077"
    ];
  };
  # sshfs is depricated
  #fileSystems."/mnt/sshfs/luminlapid" = {
  #  device = "nixos@10.0.0.183:/";
  #  fsType = "sshfs";
  #  options = [
  #    # Filesystem options
  #    "allow_other" # for non-root access
  #    "_netdev" # this is a network fs
  #    "x-systemd.automount" # mount on demand

  #    # SSH options
  #    "reconnect" # handle connection drops
  #    "ServerAliveInterval=15" # keep connections alive
  #    "IdentityFile=/var/secrets/id_ed25519"
  #    "debug"
  #  ];
  #};

  # Allow unfree packages
  #nixpkgs.config.allowUnfree = true; # Allow any unfree software
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"
      "zoom"
      "rar"
      "discord"
      "discord-unwrapped"
    ];

  # Set environment variables
  environment = {
    shells = [
      pkgs.bash
      pkgs.zsh
    ];
    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = [ pkgs.neovim ];
  };

  #services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.dbus.packages = [ pkgs.gcr ];

  security.sudo-rs = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = true;
  };

  # AI chatbot as a systemd service
  # services.ollama = {
  #   enable = true;
  #   package = pkgs.ollama-vulkan; # Generic GPU acceleration
  #   # Optional: preload models, see https://ollama.com/library
  #   loadModels = [
  #     "nemotron-3-nano:30b"
  #     "nemotron-3-nano:4b"
  #     "tinyllama:1.1b"
  #   ];
  #   environmentVariables = {
  #     OLLAMA_CONTEXT_LENGTH = "32768";
  #   };
  # };
  #services.open-webui.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
