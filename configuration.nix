# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Apply changes via:
# sudo nixos-rebuild switch --upgrade

#{ config, pkgs, lib, qtbase, wrapQtAppsHook, ... }:
{ config,
  pkgs,
  #mkDerivation,
  #lib,
  #stdenv,
  #fetchFromGitHub,
  #fetchGit,
  #jack2,
  #which,
  #python3,
  #qtbase,
  #qttools,
  #wrapQtAppsHook,
  #liblo,
  ...
}:
let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    lib = import <nixpkgs/lib>;
    buildNodeJs = pkgs.callPackage "${<nixpkgs>}/pkgs/development/web/nodejs/nodejs.nix" {
      python = pkgs.python3;
    };

    #nodejsVersion = lib.fileContents /home/andrewj/Documents/blog-website/.nvmrc;

    #nodejs = buildNodeJs {
    #  enableNpm = false;
    #  #version = nodejsVersion;
    #  version = "23.2.0";
    #  #sha256 = "1a0zj505nhpfcj19qvjy2hvc5a7gadykv51y0rc6032qhzzsgca2";
    #  sha256 = "sha256-PPeoo2aCd1aTaR8d6QG7WXOtPAriqoexrdneUV57L8c=";
    #};

    NPM_CONFIG_PREFIX = toString ./npm_config_prefix;
    nodeDependencies = (pkgs.callPackage /home/andrewj/Documents/blog-website/default.nix {}).nodeDependencies; #node2nix from https://github.com/svanderburg/node2nix
in
{

  #nixpkgs.config.permittedInsecurePackages = [
  #  "nodejs-23"
  #];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${home-manager}/nixos"
    ];

  users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.andrewj = {
      isNormalUser = true;
      description = "Andrew Johnson";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        kdePackages.kate
        prismlauncher
      #  thunderbird
      ];
    };
  };

  home-manager.users.andrewj = { pkgs, ... }: {
    home.packages = [ pkgs.cowsay ];
    home.username = "andrewj";
    home.homeDirectory = "/home/andrewj";
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "25.05";
    /* Here goes the restf your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    programs.bash.enable = true;
    programs.git = {
      enable = true;
      userEmail = "andrew.jeffrey.johnson@gmail.com";
      userName = "Andrew-Jeffrey-Johnson";
      extraConfig = {
        init.defaultBranch = "master";
      };
    };
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  # Bootloader.
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

  networking = {
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"]; #ve-+ is a wildcard that matches all container interfaces
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
      unmanaged = [ "interface-name:ve-*" ]; #If you are using Network Manager, you need to explicitly prevent it from managing container interfaces
    };
  };

  # Test container
  containers.webserver = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11"; # Go to http://192.168.100.11 to view the website
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    config = { config, pkgs, lib, ... }: {

      services.httpd = {
        enable = true;
        adminAddr = "admin@example.org";
      };

      networking = {
        firewall.allowedTCPPorts = [ 80 ];

        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;

      system.stateVersion = "24.11";
    };
  };
#------------------------------------------------------------------------------
  # Personal Blog
  containers.blog = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.13"; # Go to http://192.168.100.13 to view the website
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::4";

    bindMounts = {
      "/home/blogger/blog" = { #/path/in/container
        hostPath = "/home/andrewj/Documents/blog-website/"; #/path/on/host
        isReadOnly = false;
      };
      "/home/blogger/blog/node_modules" = {
        hostPath = "${nodeDependencies}/lib/node_modules";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, lib, ... }: {
      environment.systemPackages = with pkgs; [
        cowsay
        nodejs_23
        nodePackages.npm
      ];

      users = {
        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.blogger = {
          password = "welcome";
          isNormalUser = true;
          description = "Blogger";
          #createHome = true;

          #extraGroups = [ "networkmanager" "wheel" ];
          packages = with pkgs; [
            #pkgs.nodejs_23
            #pkgs.nodejs_14
            #nodePackages.npm
          ];
        };
      };

      services.httpd = {
        enable = true;
        adminAddr = "admin@example.org";
      };

      systemd.services.foo = {
        serviceConfig = {
          #ExecStart="";
        };
        script = ''
          touch /home/blogger/blog/log.txt
          /run/current-system/sw/bin/node /home/blogger/blog/index.js &>> /home/blogger/blog/log.txt
        '';
        #wantedBy = ["default.target"];
        wantedBy = ["multi-user.target"];
      };

      networking = {
        firewall.allowedTCPPorts = [ 80 3000 ];

        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;

      system.stateVersion = "25.05";
    };
  };
#------------------------------------------------------------------------------
  # Thalion's Compass OpenProject
  containers.tc = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.14"; # Go to http://192.168.100.13 to view the website
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::5";

    #bindMounts = {
    #  "/home/tc/openproject" = { #/path/in/container
    #    hostPath = "/home/andrewj/Documents/blog-website/"; #/path/on/host
    #    isReadOnly = false;
    #  };
    #  "/home/blogger/blog/node_modules" = {
    ##    hostPath = "${nodeDependencies}/lib/node_modules";
    #    isReadOnly = false;
    #  };
    #};

    config = { config, pkgs, lib, ... }: {
      users = {
        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.blogger = {
          password = "welcome";
          isNormalUser = true;
          description = "Blogger";
          #extraGroups = [ "networkmanager" "wheel" ];
          packages = with pkgs; [
            pkgs.nodejs_23
            #pkgs.nodejs_14
            nodePackages.npm
          ];
        };
      };


      services.httpd = {
        enable = true;
        adminAddr = "admin@example.org";
      };

      environment.systemPackages = with pkgs; [
        cowsay
      ];

      networking = {
        firewall.allowedTCPPorts = [ 80 ];

        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;

      system.stateVersion = "25.05";
    };
  };

#------------------------------------------------------------------------------

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
    # Trusted users
    settings.trusted-users = [ "root" "@wheel" ];
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      # Automatically optimize store every build
      auto-optimise-store = true;
      # Enable nix flakes
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Automatically upgrade nixOS itself
  system.autoUpgrade.enable  = true;

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
  services.xserver.videoDrivers = ["nvidia"];
  #boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];


  hardware = {
    # Enable OpenGL
    graphics = {
      enable = true;
    };
    nvidia = {

      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    nvidia.prime = {
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
  };
  nixpkgs.config.nvidia.acceptLicense = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.enable = true; # optional
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
    kdePackages.poppler
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    kdePackages.sonnet
    kdePackages.isoimagewriter
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.kirigami-gallery
    kdePackages.plasma-nm
    kdePackages.kdeconnect-kde
    kdePackages.knetwalk
    kdePackages.qtconnectivity
    kdePackages.messagelib
    kdePackages.kcachegrind
    kdePackages.sweeper
    gtk3
    gtk4
    rustup
    tree
    dos2unix
    node2nix
    nodejs
    nodePackages.npm
    yarn2nix
    ninja

    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lshw
    gnupg
    jdk23
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
    #kdePackages.qt6gtk2

    # Alternate web browsers
    chromium
    kdePackages.falkon
    #(import ./yacy.nix) # requires read/write permissions. NixOS doesn't do that :(

    # Art
    krita
    gimp
    kdePackages.kdenlive

    # Organization
    kdePackages.korganizer
    kdePackages.kmail
    kdePackages.kmail-account-wizard
    kdePackages.kweather
    kdePackages.kclock
    kdePackages.marble
    #(import ./korganizer.nix)

    # Obs
    obs-studio
    obs-do
    obs-cmd
    obs-cli

    # Diagnostics
    traceroute # Network
    iotop # Disk activity
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
    aha
    busybox
    fwupd
    nvtopPackages.full
    kdePackages.kdebugsettings
    kdePackages.ksystemlog
    kdePackages.filelight
    arp-scan # Find all devices on local network: sudo arp-scan --interface=wlp4s0 --localnet
    netcat-gnu # Check ports on other devices: netcat -z -v 192.168.5.2 1714-1764

    # For latex
    texstudio
    texlive.combined.scheme-full
    #(import ./texstudio.nix) #Maybe one day I'll get it to use poppler :(

    # Torrenting
    libtorrent-rasterbar
    kdePackages.ktorrent

    # Calculator
    qalculate-qt

    # Wireshark
    wireshark

    # Timer app
    kdePackages.ktimer

    # Art
    audacity
    inkscape-with-extensions

    # Epic games launcher
    lutris

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
