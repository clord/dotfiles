{pkgs, ...}: {
  services.openssh.enable = true;

  # Restrict access to internal network only
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 8080]; # SSH, HTTP, Alt HTTP
    extraCommands = ''
      # Allow connections only from proxy and host
      iptables -A INPUT -s 10.68.3.1/32 -j ACCEPT
      iptables -A INPUT -s 10.68.3.2/32 -j ACCEPT
      iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -j DROP
    '';
  };

  # Services for edu-web and video-processor
  environment.systemPackages = with pkgs; [
    ffmpeg
    nodejs
    yarn
  ];

  # Basic web server for the education content
  services.nginx = {
    enable = true;
    virtualHosts."lectures.local" = {
      root = "/data/web";
      locations."/api/" = {
        proxyPass = "http://localhost:8080";
      };
    };
  };

  # Create directory structure for the application
  system.activationScripts.createDirectories = {
    text = ''
      mkdir -p /data/web
      mkdir -p /data/videos
      mkdir -p /data/processed
      echo "<h1>Lectures Web Interface</h1>" > /data/web/index.html
    '';
  };

  system.stateVersion = "23.11";
}
