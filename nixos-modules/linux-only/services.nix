# Common services configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services;
in {
  options.modules.services = {
    enableDocker = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Docker";
    };

    enablePodman = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Podman (rootless containers)";
    };

    enableLibvirt = mkOption {
      type = types.bool;
      default = false;
      description = "Enable libvirt for virtualization";
    };

    enableTailscale = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Tailscale VPN";
    };

    enableSyncthing = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Syncthing for file synchronization";
    };

    enablePrinting = mkOption {
      type = types.bool;
      default = false;
      description = "Enable CUPS printing service";
    };

    enableBluetooth = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Bluetooth support";
    };

    enableFlatpak = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Flatpak support";
    };
  };

  config = mkMerge [
    # Docker
    (mkIf cfg.enableDocker {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };

      environment.systemPackages = with pkgs; [
        docker-compose
        docker-credential-helpers
        dive # Docker image explorer
        lazydocker
      ];
    })

    # Podman
    (mkIf cfg.enablePodman {
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };

      environment.systemPackages = with pkgs; [
        podman-compose
        buildah
        skopeo
      ];
    })

    # Libvirt
    (mkIf cfg.enableLibvirt {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = false;
          swtpm.enable = true;
          ovmf.enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        virtiofsd
      ];
    })

    # Tailscale
    (mkIf cfg.enableTailscale {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = lib.mkDefault "client";
      };

      networking.firewall = {
        checkReversePath = "loose";
        trustedInterfaces = ["tailscale0"];
      };
    })

    # Syncthing
    (mkIf cfg.enableSyncthing {
      services.syncthing = {
        enable = true;
        dataDir = "/home/\${config.services.syncthing.user}";
        openDefaultPorts = true;
        guiAddress = "127.0.0.1:8384";
        overrideDevices = false;
        overrideFolders = false;
      };
    })

    # Printing
    (mkIf cfg.enablePrinting {
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          gutenprintBin
          hplip
          epson-escpr
          epson-escpr2
        ];
      };

      # Enable network printer discovery
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    })

    # Bluetooth
    (mkIf cfg.enableBluetooth {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
            Experimental = true;
          };
        };
      };

      services.blueman.enable = config.services.xserver.enable;
    })

    # Flatpak
    (mkIf cfg.enableFlatpak {
      services.flatpak.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [xdg-desktop-portal-gtk];
      };
    })
  ];
}
