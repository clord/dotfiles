{...}: {
  services.openssh.enable = true;

  # Restrict access to internal network only
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22]; # Only SSH
    extraCommands = ''
      # Allow connections only from proxy and host
      iptables -A INPUT -s 10.68.3.1/32 -j ACCEPT
      iptables -A INPUT -s 10.68.3.2/32 -j ACCEPT
      iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -j DROP
    '';
  };

  system.stateVersion = "23.11";
}
