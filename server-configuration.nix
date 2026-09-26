# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  system,
  inputs,
  pkgs,
  ...
}:
{
  luminlapid = {
    internationalization.enable = true;
    nixStoreSettings.enable = true;
    networking = {
      enable = true;
      hostName = "luminlapid-server";
    };
  };

  fileSystems."/mnt/samsung1TSSD" = {
    device = "/dev/disk/by-uuid/22802FEF-F9B0-4F34-81BA-4C0870D158F0";
    fsType = "ext4";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Secret for WireGuard
  age.secrets.wireguard-private-key = {
    file = ./secrets/wireguard-private-key.age;
    owner = "nixos";
    group = "users";
  };
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "10.0.0.0/8";
        "hosts deny" = "ALL";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "public" = {
        "path" = "/mnt/Shares/Public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0655";
        "directory mask" = "0755";
        "force user" = "nixos";
        "force group" = "users";
        "vfs objects" = "streams_xattr";
      };
      "private" = {
        "path" = "/mnt/Shares/Private";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0655";
        "directory mask" = "0755";
        "force user" = "nixos";
        "force group" = "users";
        "vfs objects" = "streams_xattr";
      };
      "jellyfin" = {
        "path" = "/jellyfin";
        "browseable" = "yes";
        "available" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0665";
        "directory mask" = "0775";
        "force user" = "nixos";
        "force group" = "jellyfin";
        "vfs objects" = "streams_xattr";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
  };
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      # for NFSv3; view with rpcinfo -p
      allowedTCPPorts = [
        51820 # WireGuard
        80
        443
        25565
      ];
      allowedUDPPorts = [
        51820 # WireGuard
        80
        443
        25565
      ];
    };
    # WireGuard VPN
    wireguard.interfaces = {
      wg0 = {
        # I followed this guide: https://thehightechsociety.com/how-to-use-wireguard/
        # Determines the IP address and subnet of the server's end of the tunnel interface.
        #ips = [ "10.0.0.183/24" ];

        # The port that WireGuard listens to. Must be accessible by the client.
        listenPort = 51820;

        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 67.189.62.213/24 -o eth0 -j MASQUERADE
        '';

        # This undoes the above command
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 67.189.62.213/24 -o eth0 -j MASQUERADE
        '';

        # Path to the private key file.
        #
        # Note: The private key can also be included inline via the privateKey option,
        # but this makes the private key world-readable; thus, using privateKeyFile is
        # recommended.
        privateKeyFile = config.age.secrets.wireguard-private-key.path;

        peers = [
          # List of allowed peers.
          #{ # Feel free to give a meaningful name
          # Public key of the peer (not a file path).
          #  publicKey = "{client public key}";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          #  allowedIPs = [ "10.100.0.2/32" ];
          #}
          {
            # Andrew's Phone
            publicKey = "8Uuwm470YptkTrUOo4eujEaxlfDPhPFwJ5fn98ijBHE=";
            allowedIPs = [ "10.0.0.68/32" ];
          }
          {
            # Ave's Phone
            publicKey = "jWRnrWupWyWUQMJCvvQHeXMQCDgRNl2ZrCIXJnImCUg=";
            allowedIPs = [ "10.0.0.102/32" ];
          }
        ];
      };
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
        "jellyfin"
      ];
    };
    calibre-server = {
      isNormalUser = false; # Don't set group to users or create home
      description = "User that the calibre server runs under";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = [
      pkgs.neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      pkgs.git
      inputs.agenix.packages.${system}.default
      pkgs.adcli
      pkgs.realmd
      pkgs.samba
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
  };

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
    port = 8383;
    host = "127.0.0.4";
    user = "calibre-server";
    libraries = [
      "/var/lib/calibre-server/calibrelibrary"
    ];
    auth = {
      enable = true;
      mode = "basic";
    };
    extraFlags = [
      "--userdb"
      "/var/lib/calibre-server/users.sqlite"
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
      "/calibre" = {
        # EPUB content server
        # The slash on the end ensure url passed to calibre-server starts
        # with / instead of /calibre-server
        proxyPass = "http://127.0.0.4:8383/";
        #proxyWebsockets = true;
      };
      "/static/" = {
        #defaultType = "text/plain";
        #return =  "200 $request_uri";
        #root = "/home/nginx";
        #extraConfig = "autoindex on";
        tryFiles = "$uri =404";
      };
    };
  };
  #services.nginx.virtualHosts."nfs.luminlapid.com" = {
  #  root = "/";
  #  locations = {
  #    "/" = {
  #      proxyPass = "192.168.100.183:2049";
  #    };
  #  };
  #};

  # Automated certificate authority for luminlapid.com
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
