{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.root.hashedPasswordFile = config.age.secrets.rootPasswd.path;

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    pulseaudio.enable = false;
  };

  boot = {
    initrd = {
      kernelModules = ["zfs"];
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sr_mod"];

      # Setup keyfile
      secrets = {"/crypto_keyfile.bin" = null;};
      luks = {
        devices = {
          # You'll need to replace these UUIDs with the actual ones for jasper
          "luks-root" = {
            device = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
          };

          # Enable swap on luks if needed
          "luks-swap" = {
            device = "/dev/disk/by-uuid/yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
            keyFile = "/crypto_keyfile.bin";
          };
        };
      };
    };
    kernelModules = ["kvm-intel" "zfs"];
    extraModulePackages = [];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    supportedFilesystems = ["zfs"];
    zfs.requestEncryptionCredentials = true;
  };

  # You'll need to update these with the actual UUIDs for jasper
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/AAAA-BBBB";
    fsType = "vfat";
  };

  # ZFS filesystems
  fileSystems."/media" = {
    device = "sam";
    fsType = "zfs";
  };

  fileSystems."/dozer" = {
    device = "dozer";
    fsType = "zfs";
  };

  fileSystems."/dozer/photos" = {
    device = "dozer/photos";
    fsType = "zfs";
  };

  fileSystems."/dozer/photos/gidget" = {
    device = "dozer/photos/gidget";
    fsType = "zfs";
  };

  fileSystems."/dozer/photos/snowbie" = {
    device = "dozer/photos/snowbie";
    fsType = "zfs";
  };

  fileSystems."/dozer/users" = {
    device = "dozer/users";
    fsType = "zfs";
  };

  fileSystems."/dozer/users/Backups" = {
    device = "dozer/users/Backups";
    fsType = "zfs";
  };

  fileSystems."/dozer/users/Backups/Leduc" = {
    device = "dozer/users/Backups/Leduc";
    fsType = "zfs";
  };

  fileSystems."/dozer/users/Home" = {
    device = "dozer/users/Home";
    fsType = "zfs";
  };

  fileSystems."/dozer/users/ISOs" = {
    device = "dozer/users/ISOs";
    fsType = "zfs";
  };

  fileSystems."/dozer/users/Photos" = {
    device = "dozer/users/Photos";
    fsType = "zfs";
  };

  fileSystems."/dozer/users/Shared" = {
    device = "dozer/users/Shared";
    fsType = "zfs";
  };

  fileSystems."/dozer/users/Wikipedia" = {
    device = "dozer/users/Wikipedia";
    fsType = "zfs";
  };

  fileSystems."/dozer/DISKs" = {
    device = "dozer/DISKs";
    fsType = "zfs";
  };

  fileSystems."/dozer/DNS" = {
    device = "dozer/DNS";
    fsType = "zfs";
  };

  fileSystems."/dozer/GRIMSHAW" = {
    device = "dozer/GRIMSHAW";
    fsType = "zfs";
  };

  fileSystems."/dozer/Library" = {
    device = "dozer/LIBRARY";
    fsType = "zfs";
  };

  fileSystems."/dozer/MKVs" = {
    device = "dozer/MKVs";
    fsType = "zfs";
  };

  fileSystems."/dozer/TUCK" = {
    device = "dozer/TUCK";
    fsType = "zfs";
  };

  fileSystems."/dozer/UniFi" = {
    device = "dozer/UNIFI";
    fsType = "zfs";
  };

  fileSystems."/dozer/wiki" = {
    device = "dozer/wiki";
    fsType = "zfs";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/wwwwwwww-wwww-wwww-wwww-wwwwwwwwwwww";}];

  networking = {
    hostName = "jasper";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault false;

    # Server static IP configuration
    interfaces.enp0s31f6 = {
      # Replace with actual interface name
      ipv4.addresses = [
        {
          address = "10.68.3.2"; # Server's IP address
          prefixLength = 24; # /24 subnet (255.255.255.0)
        }
      ];
    };
    defaultGateway = "10.68.3.1";
    nameservers = ["1.1.1.1" "8.8.8.8"];

    # Host names for easy reference inside containers
    hosts = {
      "10.68.3.15" = ["goatbook-v1"];
      "10.68.3.16" = ["goatbook-v2"];
      "10.68.3.17" = ["homeauth"];
      "10.68.3.19" = ["monitoring"];
      "10.68.3.5" = ["edson" "lectures" "plex"];
      "10.68.3.9" = ["robson" "torrents"];
      "10.68.3.10" = ["burns" "smb"];
      "10.68.3.14" = ["maymont"];
      "10.68.3.18" = ["mundare" "db"];
    };
  };

  # Container networking
  networking.nat = {
    enable = true;
    enableIPv6 = false;
    internalInterfaces = ["ve-+"];
    externalInterface = "enp0s31f6"; # Replace with actual interface name
  };

  # Enable IP forwarding for containers
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # Firewall configuration - only allow external access to the proxy server and SSH
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443]; # SSH, HTTP, HTTPS
    extraCommands = ''
      # Allow all traffic from internal container network
      iptables -A INPUT -s 10.68.3.0/24 -j ACCEPT
      # Allow connections to established sessions
      iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
  };

  # ZFS services
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      frequent = 4;
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
    };
  };

  # Container definitions
  containers = {
    goatbook-v1 = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.15";

      config = import ./containers/goatbook-v1.nix;
    };

    goatbook-v2 = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.16"; # New IP for v2

      config = import ./containers/goatbook-v2.nix;
    };

    homeauth = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.17"; # New IP for homeauth

      config = import ./containers/homeauth.nix;
    };

    monitoring = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.19";

      config = import ./containers/monitoring.nix;
    };

    lectures = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.5"; # edson

      bindMounts = {
        "/data" = {
          hostPath = "/dozer/users/Shared/lectures";
          isReadOnly = false;
        };
      };

      config = import ./containers/lectures.nix;
    };

    plex = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.5"; # edson (same as lectures)

      bindMounts = {
        "/media" = {
          hostPath = "/media";
          isReadOnly = false;
        };
      };

      config = import ./containers/plex.nix;
    };

    torrents = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.9"; # robson

      bindMounts = {
        "/downloads" = {
          hostPath = "/media/downloads";
          isReadOnly = false;
        };
      };

      config = import ./containers/torrents.nix;
    };

    smb = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.10"; # burns

      bindMounts = {
        "/dozer" = {
          hostPath = "/dozer";
          isReadOnly = false;
        };
        "/media" = {
          hostPath = "/media";
          isReadOnly = false;
        };
      };

      config = import ./containers/smb.nix;
    };

    maymont = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.14"; # maymont

      bindMounts = {
        "/projects" = {
          hostPath = "/dozer/users/Home/projects";
          isReadOnly = false;
        };
      };

      config = import ./containers/maymont.nix;
    };

    db = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.18"; # mundare

      bindMounts = {
        "/data" = {
          hostPath = "/dozer/users/Shared/db_data";
          isReadOnly = false;
        };
      };

      config = import ./containers/db.nix;
    };

    nginx-proxy-server = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.68.3.1";
      localAddress = "10.68.3.1";

      # Make this container's ports accessible from the host
      extraVeths = {
        # This creates a direct link to the host for this container only
        proxy-host = {
          hostBridge = "br0"; # Assuming br0 exists or will be created
          forwardPorts = [
            {
              hostPort = 80;
              containerPort = 80;
              protocol = "tcp";
            }
            {
              hostPort = 443;
              containerPort = 443;
              protocol = "tcp";
            }
          ];
        };
      };

      config = import ./containers/nginx-proxy-server.nix;
    };
  };

  # Enable services on the host
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    # Host-level monitoring
    prometheus.exporters.node = {
      enable = true;
      enabledCollectors = ["systemd" "zfs"];
      openFirewall = false; # Only accessible from internal network
    };

    # Create bridge for proxy server
    # This allows the nginx proxy container to receive traffic directly
  };

  # Create bridge for proxy server
  # This allows the nginx proxy container to receive traffic directly
  networking.bridges = {
    br0 = {
      interfaces = [];
    };
  };

  # System maintenance
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    zfs
    lsof
    wget
    curl
    tmux
    parted
    gptfdisk
    iotop
    rsync
    ncdu
    nmap
    smartmontools
    pciutils
    usbutils
    dnsutils
    inetutils
  ];

  # Default state version for this NixOS configuration
  system.stateVersion = "23.11";
}
