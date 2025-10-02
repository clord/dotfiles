{...}: {
  services.openssh.enable = true;

  # Restrict access to internal network only
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443]; # SSH, HTTP, HTTPS
    extraCommands = ''
      # Allow connections only from proxy and host
      iptables -A INPUT -s 10.68.3.1/32 -j ACCEPT
      iptables -A INPUT -s 10.68.3.2/32 -j ACCEPT
      iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -j DROP
    '';
  };

  # Basic web server for authentication services
  services.nginx = {
    enable = true;
    virtualHosts."homeauth.local" = {
      root = "/var/www/homeauth";
    };
  };

  # Create directory for web content
  system.activationScripts.createHomauthDir = {
    text = ''
      mkdir -p /var/www/homeauth
      echo "<h1>Home Authentication Service</h1>" > /var/www/homeauth/index.html
    '';
  };

  system.stateVersion = "23.11";
}
