# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Apply changes via:
# sudo nixos-rebuild switch --upgrade

#{ config, pkgs, lib, qtbase, wrapQtAppsHook, ... }:
{ config,
  pkgs,
  mkDerivation,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchGit,
  jack2,
  which,
  python3,
  qtbase,
  qttools,
  wrapQtAppsHook,
  liblo,
  ...
}:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Trusted users
  nix.settings.trusted-users = [ "root" "@wheel" ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/"; # ← use the same mount point here.
    };
    grub = {
      efiSupport = true;
      #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      device = "nodev";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Automatically optimize store every build
  nix.settings.auto-optimise-store = true;

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatically upgrade nixOS itself
  system.autoUpgrade.enable  = true;

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    driSupport = true;
  };

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
  services.xserver.enable = false;

  # Me trying to get desktop environment to work
  #services.xserver.videoDrivers = [ "nouveau" "nvidia" "nvidia_drm" ];
  services.xserver.videoDrivers = [ "nouveau" ];
  #services.xserver.videoDrivers = [ "nouveau" "nvidia" ];
  #boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];


  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    # Option A
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Option B
    #sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  #nixpkgs.config.nvidia.acceptLicense = true;
  

  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.enable = true; # optional
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  # My fix to start plasma desktop environment upon startup
  #services.displayManager.sddm.settings.General.DisplayServer = "x11-user";

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrewj = {
    isNormalUser = true;
    description = "Andrew Johnson";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      prismlauncher
    #  thunderbird
    ];
  };

  #users.extraUsers.andrewj.extraGroups = [ "wheel" ];

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "andrewj";

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Development packages
    cmake
    git
    poppler_gi
    poppler
    kdePackages.poppler
    poppler_utils
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    kdePackages.sonnet
    gtk2
    gtk3
    gtk4
    cargo
    rustup
    tree
    dos2unix
    ninja

    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lshw
    gnupg
    jdk8
    jdk17
    jdk21
    jdk22
    vlc

    # For color management
    kdePackages.colord-kde
    displaycal

    # For sharing audio when sharing desktop
    vesktop

    # For libreoffice
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US
    kdePackages.qt6gtk2

    # Testing compilation programs
    #(import ./my-hello.nix)

    # Chromium
    chromium

    # Art
    krita
    gimp-with-plugins

    # Organization
    kdePackages.korganizer
    kdePackages.kmail
    kdePackages.kmail-account-wizard
    kdePackages.kweather
    #(import ./korganizer.nix)

    # Obs
    obs-studio
    obs-do
    obs-cmd
    obs-cli

    # Diagnostics
    traceroute # Network
    iotop # Disk activity

    # Debugging Wayland
    wlcs
    wev
    (import ./wayland-debug.nix)
    xorg.xwininfo #Can be used to determine if a particular program uses XWayland
    xorg.xprop #Can be used to determine if a particular program uses XWayland
    xorg.xlsclients #Lists XWayland programs
    clinfo
    virtualglLib
    vulkan-tools
    gpu-viewer
    wayland-utils
    kdePackages.libksysguard
    kdePackages.plasma-workspace
    kdePackages.plasma-sdk

    # For latex
    texstudio
    texlive.combined.scheme-full
    #(import ./texstudio.nix) #Maybe one day I'll get it to use poppler :(

    # qBittorrent
    libtorrent-rasterbar
    boost
    (import ./my-qBittorrent.nix)

    # Clockify
    #clockify

    # Calculator
    qalculate-qt

    # Wireshark
    # (import ./wireshark.nix)
    wireshark

    # Timer app
    kdePackages.ktimer

    # Art
    audacity
    inkscape-with-extensions

    # Epic games launcher
    lutris

    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # support 32-bit only
    wine

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })

    # support 64-bit only
    wine64

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
  ];



  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = lib.mkForce pkgs.pinentry-qt;
    enableSSHSupport = true;
  };
  services.dbus.packages = [ pkgs.gcr ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
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

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
