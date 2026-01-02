# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Apply changes via:
# sudo nixos-rebuild switch --upgrade
#{ config, pkgs, lib, qtbase, wrapQtAppsHook, ... }:
{ config, ... }:
let
  # We pin to a specific nixpkgs commit for reproducibility.
  # Last updated: 15 November 2025. Check for new commits at https://status.nixos.org.
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    config.allowUnfree = true;
  };
  lib = import <nixpkgs/lib>;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
      ];
    };
  };

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    grub = {
      enable = false;
      efiSupport = true;
      #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      device = "nodev";
      useOSProber = true;
    };
    systemd-boot = {
      enable = true;
    };
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

  # Automatically upgrade nixOS itself
  #system.autoUpgrade.enable  = true;

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Me trying to get desktop environment to work
  #boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware = {
    # Enable OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.enable = false; # optional
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "andrew";

  # Install firefox.
  #programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.hyprland.enable = true; # enable Hyprland

  # Install docker rootless
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Install waydroid for running Android apps in containers
  virtualisation.waydroid.enable = true;

  # Android emulation
  programs.adb.enable = true; # Android Debugger

  # Emulation and virtualization
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "andrew" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

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

      # native wayland support (unstable)
      pkgs.wineWowPackages.waylandFull
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
    #pinentryPackage = lib.mkForce pkgs.pinentry-qt;
    enableSSHSupport = true;
  };
  services.dbus.packages = [ pkgs.gcr ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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

  services.udisks2.enable = true;

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
