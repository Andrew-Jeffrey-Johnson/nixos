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
#let
# We pin to a specific nixpkgs commit for reproducibility.
# Last updated: 15 November 2025. Check for new commits at https://status.nixos.org.
#pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
#  config.allowUnfree = true;
#};
#pkgs = import nixpkgs {
#  system = "x86_64-linux";
#  config.allowUnfree = true;
#};
#lib = pkgs.lib;
#in
{
  imports = [
    # Include the results of the hardware scan.
    #./hardware-configuration.nix
  ];

  users = {
    groups.docker = { };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.andrew = {
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
    };
  };

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

  fileSystems."/boot" = {
    options = [
      "uid=0"
      "gid=0"
      "fmask=0077"
      "dmask=0077"
    ];
  };

  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ]; # ve-+ is a wildcard that matches all container interfaces
      externalInterface = "ens3";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
    hostName = "nixos"; # Define your hostname.
    #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ]; # If you are using Network Manager, you need to explicitly prevent it from managing container interfaces
    };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix = {
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      download-buffer-size = 500000000; # 500 MB
      # Automatically optimize store every build
      auto-optimise-store = true;
      # Enable nix flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = false;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ]; # Video drivers

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.xwayland.enable = true; # Support for X11 apps

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install docker rootless
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Install flatpak globally
  services.flatpak.enable = true;

  # Install waydroid for running Android apps in containers
  virtualisation.waydroid.enable = true;

  # Emulation and virtualization
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

  # Set environment variables
  environment = {
    shells = [ pkgs.bash ];
    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = [
      pkgs.dict
      pkgs.dictdDBs.wordnet
      pkgs.dictdDBs.wiktionary

      # Android emulator
      pkgs.android-tools
    ];
  };

  # Get all the nerfonts fonts
  fonts.packages = [
    pkgs.dejavu_fonts
    pkgs.font-awesome
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.dbus.packages = [ pkgs.gcr ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    protontricks.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];

  # List services that you want to enable:

  security.sudo-rs = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = true;
  };

  services.dictd = {
    enable = true;
    DBs = [
      pkgs.dictdDBs.wiktionary
      pkgs.dictdDBs.wordnet
    ];
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
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-rocm;
  };
  services.open-webui.enable = true;

  services.udisks2.enable = true;

  # Databases
  # database with a default user and password
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];
    enableTCPIP = true;
    # port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      local all      all     trust
      # ... other auth rules ...

      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host  all      all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };

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
