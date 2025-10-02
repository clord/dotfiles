{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.root.password = "test"; # Simple password for testing

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    pulseaudio.enable = false;
  };

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sr_mod"];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    loader = {
      grub.enable = false;
    };
    supportedFilesystems = ["zfs"];
  };

  # Simple VM filesystems
  fileSystems = {
    "/" = {
      device = "/dev/vda1";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "jasper-test";
    hostId = "12345678"; # Required for ZFS
    networkmanager.enable = true;
    useDHCP = lib.mkDefault false;

    # Test static IP configuration (10.70.3.x instead of 10.68.3.x)
    interfaces.enp0s1 = {
      ipv4.addresses = [
        {
          address = "10.70.3.2"; # Test server IP
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "10.70.3.1";
    nameservers = ["1.1.1.1" "8.8.8.8"];

    # Host names for containers (adjusted to 10.70.3.x)
    hosts = {
      "10.70.3.15" = ["goatbook-v1"];
      "10.70.3.16" = ["goatbook-v2"];
      "10.70.3.17" = ["homeauth"];
      "10.70.3.19" = ["monitoring"];
      "10.70.3.5" = ["edson" "lectures" "plex"];
      "10.70.3.9" = ["robson" "torrents"];
      "10.70.3.10" = ["burns" "smb"];
      "10.70.3.14" = ["maymont"];
      "10.70.3.18" = ["mundare" "db"];
    };
  };

  # Container networking
  networking.nat = {
    enable = true;
    enableIPv6 = false;
    internalInterfaces = ["ve-+"];
    externalInterface = "enp0s1";
  };

  # Enable IP forwarding for containers
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443];
    extraCommands = ''
      # Allow all traffic from internal container network
      iptables -A INPUT -s 10.70.3.0/24 -j ACCEPT
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

  # Container definitions (adjusted to 10.70.3.x network)
  containers = {
    goatbook-v1 = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.15";

      config = import ./containers/goatbook-v1.nix;
    };

    goatbook-v2 = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.16";

      config = import ./containers/goatbook-v2.nix;
    };

    homeauth = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.17";

      config = import ./containers/homeauth.nix;
    };

    monitoring = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.19";

      config = import ./containers/monitoring.nix;
    };

    lectures = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.5";

      bindMounts = {
        "/data" = {
          hostPath = "/testdata/lectures";
          isReadOnly = false;
        };
      };

      config = import ./containers/lectures.nix;
    };

    plex = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.5";

      bindMounts = {
        "/media" = {
          hostPath = "/testdata/media";
          isReadOnly = false;
        };
      };

      config = import ./containers/plex.nix;
    };

    torrents = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.9";

      bindMounts = {
        "/downloads" = {
          hostPath = "/testdata/downloads";
          isReadOnly = false;
        };
      };

      config = import ./containers/torrents.nix;
    };

    smb = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.10";

      bindMounts = {
        "/dozer" = {
          hostPath = "/testdata/dozer";
          isReadOnly = false;
        };
        "/media" = {
          hostPath = "/testdata/media";
          isReadOnly = false;
        };
      };

      config = import ./containers/smb.nix;
    };

    maymont = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.14";

      bindMounts = {
        "/projects" = {
          hostPath = "/testdata/projects";
          isReadOnly = false;
        };
      };

      config = import ./containers/maymont.nix;
    };

    db = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.18";

      bindMounts = {
        "/data" = {
          hostPath = "/testdata/db_data";
          isReadOnly = false;
        };
      };

      config = import ./containers/db.nix;
    };

    nginx-proxy-server = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.70.3.1";
      localAddress = "10.70.3.1";

      extraVeths = {
        proxy-host = {
          hostBridge = "br0";
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
        PermitRootLogin = lib.mkForce "yes"; # For testing
        PasswordAuthentication = lib.mkForce true; # For testing
      };
    };

    # Host-level monitoring
    prometheus.exporters.node = {
      enable = true;
      enabledCollectors = ["systemd" "zfs"];
      openFirewall = false;
    };
  };

  # Create bridge for proxy server
  networking.bridges = {
    br0 = {
      interfaces = [];
    };
  };

  # System maintenance
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = lib.mkForce "--delete-older-than 30d";
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
