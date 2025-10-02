{...}: {
  services.openssh.enable = true;

  # Restrict access to internal network only
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 9091 51413]; # SSH, Transmission web, Transmission peer
    allowedUDPPorts = [51413]; # Transmission peer UDP
    extraCommands = ''
      # Allow connections only from proxy and host
      iptables -A INPUT -s 10.68.3.1/32 -j ACCEPT
      iptables -A INPUT -s 10.68.3.2/32 -j ACCEPT
      iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Allow incoming BitTorrent connections
      iptables -A INPUT -p tcp --dport 51413 -j ACCEPT
      iptables -A INPUT -p udp --dport 51413 -j ACCEPT
      iptables -A INPUT -j DROP
    '';
  };

  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/downloads/complete";
      incomplete-dir = "/downloads/incomplete";
      incomplete-dir-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,10.68.3.*";
      rpc-whitelist-enabled = true;
      rpc-authentication-required = true;
      rpc-username = "admin"; # Consider using secrets management
      rpc-password = "{changeme}"; # Should be replaced with a proper password hash
    };
  };

  system.stateVersion = "23.11";
}
