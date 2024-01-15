{ config, lib, pkgs, restedpi, ... }: with lib; let 
  restedpi = config.restedpi; 
  simple-overlay = { target, status }: {
    name = "${target}-${status}-overlay";
    dtsText = ''
      /dts-v1/;
      /plugin/;
      / {
        compatible = "brcm,bcm2711";
        fragment@0 {
          target = <&${target}>;
          __overlay__ {
            status = "${status}";
          };
        };
      };
    '';
  };
in {
  options.restedpi = lib.mkOption {
    type = lib.types.package;
    defaultText = lib.literalExpression "pkgs.restedpi";
    description = lib.mdDoc "The restedpi package to use.";
  };
  config = { 
  environment.systemPackages = with pkgs; [ i2c-tools ];

  #hardware.bluetooth.powerOnBoot = false;
  hardware = #lib.mkMerge [
   # (lib.mkIf cfg.i2c0.enable {
   #   i2c.enable = lib.mkDefault true;
   #   deviceTree = {
   #     overlays = [ (simple-overlay { target = "i2c0if"; status = "okay"; }) ];
   #   };
   # })
    {
      bluetooth.powerOnBoot = false;
      i2c.enable = lib.mkDefault true;
      deviceTree = {
        overlays = [ (simple-overlay { target = "i2c1"; status = "okay"; }) ];
      };
    };
#  ];

  networking = {
    hostName = "chickenpi";
    wireless.enable = false;
    useDHCP = true;
  };

  boot = {
    loader.grub.enable = false;
    initrd.availableKernelModules = [ "xhci_pci" ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
  swapDevices = [ ];


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

