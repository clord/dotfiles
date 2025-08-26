{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.networking;
in {
  options.modules.networking = {
    enable = mkEnableOption "common networking configuration";

    hostName = mkOption {
      type = types.str;
      description = "The system hostname";
    };

    enableNetworkManager = mkOption {
      type = types.bool;
      default = true;
      description = "Enable NetworkManager for network configuration";
    };

    enableFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the firewall";
    };

    allowedTCPPorts = mkOption {
      type = types.listOf types.port;
      default = [];
      description = "List of allowed TCP ports";
    };

    allowedUDPPorts = mkOption {
      type = types.listOf types.port;
      default = [];
      description = "List of allowed UDP ports";
    };

    enableIPv6 = mkOption {
      type = types.bool;
      default = true;
      description = "Enable IPv6 support";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = cfg.enableNetworkManager;

      firewall = {
        enable = cfg.enableFirewall;
        allowedTCPPorts = cfg.allowedTCPPorts;
        allowedUDPPorts = cfg.allowedUDPPorts;
      };

      enableIPv6 = cfg.enableIPv6;

      # Common network optimizations
      useDHCP = lib.mkDefault true;

      # DNS configuration
      nameservers = lib.mkDefault [
        "10.68.3.4"
        "1.1.1.1"
        "1.0.0.1"
      ];
    };

    # Network-related packages
    environment.systemPackages = with pkgs; [
      networkmanager
      dig
      nmap
      traceroute
      mtr
      iperf3
      tcpdump
      netcat
    ];

    # Enable mDNS for local network discovery
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
  };
}
