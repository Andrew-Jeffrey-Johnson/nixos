# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    #./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  nix = {
    settings = {
      # Enable nix flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Define a user account.
  users.users = {
    nixos = {
      isNormalUser = true;
      description = "Generic work account";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = [ ];
    };
    calibre-server = {
      isNormalUser = false; # Don't set group to users or create home
      description = "User that the calibre server runs under";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  services.calibre-server = {
    enable = true;
    port = 58816;
    host = "127.0.0.1";
    user = "calibre-server";
    libraries = [
      "/var/lib/calibre-server/calibrelibrary"
    ];
  };

  #------------------------------------------------------------------------------
  # Personal blog through luminlapid.com
  containers.blog = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.13"; # Go to http://192.168.100.13 to view the website
    #hostAddress = "127.0.0.1:8000";
    #localAddress = "127.0.0.1:8000";
    #hostAddress6 = "fc00::1";
    #localAddress6 = "fc00::4";

    bindMounts = {
      "/home/blogger/blog" = {
        #/path/in/container
        hostPath = "/home/nixos/luminlapid"; # /path/on/host
        isReadOnly = false;
      };
      # You can add more bindMounts here
    };

    config =
      {
        config,
        lib,
        ...
      }:
      {
        environment.systemPackages = [
          # Only add packages here if they cannot be added to user.blogger.packages
          # due to policy of least permissions
        ];

        users = {
          # Define a user account. Don't forget to set a password with ‘passwd’.
          users.blogger = {
            password = "welcome";
            isNormalUser = true;
            description = "Blogger";
            #createHome = true;

            #extraGroups = [ "networkmanager" "wheel" ];
            packages = [
              (pkgs.python313.withPackages (
                python-pkgs: with python-pkgs; [
                  # select Python packages here
                  pandas
                  numpy
                  nptyping
                  requests
                  pyngo
                  django
                  django-types
                  django-extensions
                  django-phonenumber-field
                  nbconvert
                ]
              ))
            ];
          };
        };

        #services.httpd = {
        #  enable = true;
        #  adminAddr = "blogger@luminlapid.com";
        #};

        systemd.services.django = {
          #services.django = {
          description = "Django Development Server";
          after = [ "network.target" ];
          wants = [ "network.target" ];
          serviceConfig = {
            WorkingDirectory = "/home/blogger/blog";
            ExecStart = "/etc/profiles/per-user/blogger/bin/python /home/blogger/blog/manage.py runserver 0.0.0.0:8000"; # Change the port if needed
            #ExecStart = "${pkgs.bash}/bin/bash -c 'echo \"Hello!\" >> /home/blogger/blog/log.txt; exec python3 manage.py runserver 0.0.0.0:8000 >> /home/blogger/blog/log.txt 2>&1'";
            Restart = "always";
            User = "blogger";
            Environment = ""; # Set your Django settings
          };
          #wantedBy = ["default.target"];
          wantedBy = [ "multi-user.target" ];
        };

        networking = {
          firewall.allowedTCPPorts = [ 8000 ];

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;

        system.stateVersion = "25.05";
      };
  };
  #------------------------------------------------------------------------------

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Enable SFTP
  services.openssh.allowSFTP = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    80
    443
    25565
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Create a reverse proxy for luminlapid via nginx
  services.nginx.enable = true;
  services.nginx.virtualHosts."luminlapid.com" = {
    addSSL = true;
    enableACME = true;
    #forceSSL = false;
    #ibasicAuth = { test = "password"; };
    root = "/";
    locations = {
      "/" = {
        proxyPass = "http://192.168.100.13:8000";
        proxyWebsockets = true;
      };
      "/static/" = {
        #defaultType = "text/plain";
        #return =  "200 $request_uri";
        #root = "/home/nginx";
        #extraConfig = "autoindex on";
        tryFiles = "$uri =404";
      };
      "/calibre-server" = {
        # EPUB content server
        proxyPass = "http://127.0.0.1:58816";
        proxyWebsockets = true;
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "andrew.jeffrey.johnson@gmail.com";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
