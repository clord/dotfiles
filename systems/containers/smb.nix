_: {
  services.openssh.enable = true;

  # SMB typically needs to be directly accessible on the LAN
  # so we'll forward these ports from the host
  networking.firewall = {
    enable = true;
    # SMB, SSH, and Syncthing ports
    allowedTCPPorts = [22 139 445 8384 22000];
    allowedUDPPorts = [137 138 21027 22000];
  };

  services = {
    samba = {
      enable = true;
      securityType = "user";
      openFirewall = false; # We're manually configuring the firewall
      shares = {
        media = {
          path = "/media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
        };
        dozer = {
          path = "/dozer";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
        };
      };
      settings = {
        global = {
          # Only allow connections from local network
          "hosts allow" = "10.68.3. 127.0.0.1";
          "hosts deny" = "all";
          # Security settings
          "server signing" = "mandatory";
          "smb encrypt" = "required";
        };
      };
    };

    syncthing = {
      enable = true;
      openDefaultPorts = false; # We're manually configuring the firewall
      settings = {
        gui = {
          address = "0.0.0.0:8384";
        };
        options = {
          globalAnnounceEnabled = false; # Don't announce to global discovery
          relaysEnabled = false; # Don't use relays
          natEnabled = false; # Don't use NAT traversal
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
