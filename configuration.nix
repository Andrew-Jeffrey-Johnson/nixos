# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Apply changes via:
# sudo nixos-rebuild switch --upgrade

#{ config, pkgs, lib, qtbase, wrapQtAppsHook, ... }:
{ config, ... }:
let
    # We pin to a specific nixpkgs commit for reproducibility.
    # Last updated: 2025-03-05. Check for new commits at https://status.nixos.org.
    pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/02032da4af073d0f6110540c8677f16d4be0117f.tar.gz") { config.allowUnfree = true; };
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/486b066025dccd8af7fbe5dd2cc79e46b88c80da.tar.gz";
    lib = import <nixpkgs/lib>;
in
{
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
    };
  };
  home-manager.useGlobalPkgs = true;
  home-manager.users.andrewj = {
    home.packages = [
      pkgs.jdk23
      pkgs.libreoffice-fresh
      pkgs.hunspell
      pkgs.hunspellDicts.en_US-large
      pkgs.prismlauncher
      pkgs.lutris
      pkgs.kdePackages.kate
      pkgs.qalculate-qt
      pkgs.qbittorrent
      pkgs.chromium
      pkgs.kdePackages.falkon
      pkgs.librewolf
      pkgs.gimp
      pkgs.audacity
      pkgs.inkscape
      pkgs.texstudio
      pkgs.texlive.combined.scheme-full
      pkgs.vlc
      pkgs.kdePackages.korganizer
      pkgs.poppler
      pkgs.kdePackages.marble
      pkgs.ollama-cuda
      pkgs.tabby # Self-hosted AI coding assistant
      pkgs.quarto
      pkgs.mermaid-filter
      pkgs.pandoc
      (pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-toolsai.jupyter-keymap
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        batisteo.vscode-django
        bierner.markdown-mermaid
        james-yu.latex-workshop
        mkhl.direnv
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-mermaid-editor";
            publisher = "tomoyukim";
            version = "0.19.1";
            #sha256 = "";
            sha256 = "sha256-MZkR9wPTj+TwhQP0kbH4XqlTvQwfkbiZdfzA10Q9z5A=";
          }
          {
            name = "mermaid-markdown-syntax-highlighting";
            publisher = "bpruitt-goddard";
            version = "1.7.0";
            #sha256 = "";
            sha256 = "sha256-Vjmc9tlHSFdhhcSopUG3MnyBSi//B6cpnavqFLhVRho=";
          }
          {
            name = "quarto";
            publisher = "quarto";
            version = "1.118.0";
            #sha256 = "";
            sha256 = "sha256-fQMORF2LJKhkKbinex+c5I+kM5YM93W2XzOL8PMVZS0=";
          }
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            #sha256 = "";
            sha256 = "sha256-LxFOxkcQNCLotgZe2GKc2aGWeP9Ny1BpD1XcTqB85sI=";
          }
          {
            name = "vscode-tabby";
            publisher = "TabbyML";
            version = "1.20.1";
            #sha256 = "";
            sha256 = "sha256-/+l7TRFtO+TKmyBZ3fmbYWcP9QZ4ClHKuwDYaXKF8W8=";
          }
          {
            name = "sqlite-viewer";
            publisher = "qwtel";
            version = "0.10.2";
            #sha256 = "";
            sha256 = "sha256-5TqcxSJPSmLRBhrhVbAd1VdL2kyszezl8sSrlSynOms=";
          }
          {
            name = "latex-workshop";
            publisher = "james-yu";
            version = "10.8.0";
            #sha256 = "";
            sha256 = "sha256-tdQ3Z/OfNH0UgpHcn8Zq5rQxoetD61dossEh8hRygew=";
          }
        ];
      })
    ];
    home.username = "andrewj";
    home.homeDirectory = "/home/andrewj";
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "25.05";
    # Here goes the restf your home-manager config, e.g. home.packages = [ pkgs.foo ];
    programs.direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    programs.bash = {
      enable = true;
      initExtra = "eval \"$(direnv hook bash)\"\n"; # hook direnv
    };
    programs.git = {
      enable = true;
      userEmail = "andrew.jeffrey.johnson@gmail.com";
      userName = "Andrew-Jeffrey-Johnson";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    programs.gh = {
      enable = true;
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
#------------------------------------------------------------------------------
  # Personal Blog
  /*
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
  */
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
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    settings = {
      trusted-users = [ "root" "@wheel" ];
      download-buffer-size = 500000000; # 500 MB
      # Automatically optimize store every build
      auto-optimise-store = true;
      # Enable nix flakes
      experimental-features = [ "nix-command" "flakes" ];
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
  #services.xserver.enable = false;

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
      #package = pkgs.linuxPackages.nvidiaPackages.stable;
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
  services.xserver.enable = false; # optional
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
  environment.systemPackages = [
    pkgs.git
    pkgs.cudaPackages.cuda_nvcc # CUDA
    pkgs.cudaPackages.cudatoolkit

    pkgs.wget
    pkgs.gnupg

    # native wayland support (unstable)
    pkgs.wineWowPackages.waylandFull
    pkgs.kdePackages.kdeconnect-kde
  ];

  services.pcscd.enable = true;
  # Turn off kwallet prompts (doesn't work)
  security.pam.services.plasma6.kwallet.enable = true;
  security.pam.services.plasma.kwallet.enable = true;
  security.pam.services.plasma5.kwallet.enable = true;
  security.pam.services.qt.kwallet.enable = true;
  security.pam.services.qt5.kwallet.enable = true;
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
