{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (config) restedpi;
  simple-overlay = {
    target,
    status,
  }: {
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
    environment.systemPackages = with pkgs; [i2c-tools];
    users.users.root.hashedPasswordFile = config.age.secrets.rootPasswd.path;

    hardware = {
      bluetooth.powerOnBoot = false;
      i2c.enable = true;
      deviceTree = {
        overlays = [
          (simple-overlay {
            target = "i2c1";
            status = "okay";
          })
        ];
      };
    };

    networking = {
      hostName = "chickenpi";
      wireless.enable = false;
      interfaces.end0.ipv4.addresses = [
        {
          address = "10.68.3.17";
          prefixLength = 24;
        }
      ];
      defaultGateway = "10.68.3.254";
      nameservers = ["10.68.3.4"];
      firewall = {
        enable = true;
        allowedTCPPorts = [21 22 80 3030 9002 443];
      };
    };

    boot = {
      loader.grub.enable = false;
      initrd.availableKernelModules = ["xhci_pci"];
      initrd.kernelModules = [];
      kernelModules = [];
      extraModulePackages = [];
    };
    swapDevices = [];

    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = ["systemd"];
          port = 9002;
        };
      };
    };

    nixpkgs.hostPlatform = "aarch64-linux";

    # This value determines the NixOS release with which your system is to be
    # compatible. Read the release notes before changing.
    system.stateVersion = "24.11";

    systemd.services.restedpi = {
      enable = true;
      environment = {RUST_BACKTRACE = "1";};
      description = "restedpi exposes a graphql api on the raspberry pi";
      unitConfig = {};
      serviceConfig = {
        ExecStart = "${restedpi}/bin/restedpi --config-file ${config.age.secrets.chickenpiConfig.path} --log-level warn server";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
