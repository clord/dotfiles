{ config, lib, restedpi, ... }: with lib; let restedpi = config.restedpi; in {
  options.restedpi = lib.mkOption {
    type = lib.types.package;
    defaultText = lib.literalExpression "pkgs.restedpi";
    description = lib.mdDoc "The restedpi package to use.";
  };
  config = { 

  networking = {
    hostName = "chickenpi";
    wireless.enable = false;
    useDHCP = true;
  };

  hardware.enableRedistributableFirmware = true;
  boot = {
    loader.grub.enable = false;
    initrd.availableKernelModules = [ "xhci_pci" ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
  swapDevices = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/2178-694E";
      fsType = "vfat";
    };
  };

  hardware.bluetooth.powerOnBoot = false;

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  systemd.services.restedpi = {
    enable = true;
    environment = { RUST_BACKTRACE = "1"; };
    description = "restedpi exposes a graphql api on the raspberry pi";
    unitConfig = { };
    serviceConfig = {
      ExecStart =
        "${restedpi}/bin/restedpi --config-file /run/secrets/configuration --log-level warn server";
    };
    wantedBy = [ "multi-user.target" ];
  };

  };
}

