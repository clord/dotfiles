_: {
  services.openssh.enable = true;

  # Open ports only in this container
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "plex.local" = {
        locations."/" = {
          proxyPass = "http://10.68.3.5:32400";
          proxyWebsockets = true;
        };
      };
      "torrents.local" = {
        locations."/" = {
          proxyPass = "http://10.68.3.9:9091";
        };
      };
      "grafana.local" = {
        locations."/" = {
          proxyPass = "http://10.68.3.19:3000";
        };
      };
      "syncthing.local" = {
        locations."/" = {
          proxyPass = "http://10.68.3.10:8384";
          proxyWebsockets = true;
        };
      };
      "homeauth.local" = {
        locations."/" = {
          proxyPass = "http://10.68.3.17:80";
        };
      };
      "lectures.local" = {
        locations."/" = {
          proxyPass = "http://10.68.3.5:80";
        };
      };
      "db.local" = {
        locations."/" = {
          proxyPass = "http://10.68.3.18:5432";
          extraConfig = ''
            # Additional security for database access
            allow 10.68.3.0/24;
            deny all;
          '';
        };
      };
    };
    # Global nginx configuration
    appendHttpConfig = ''
      # Security headers
      add_header X-Frame-Options "SAMEORIGIN" always;
      add_header X-Content-Type-Options "nosniff" always;
      add_header X-XSS-Protection "1; mode=block" always;
      add_header Referrer-Policy "no-referrer-when-downgrade" always;

      # Logging configuration
      log_format detailed '$remote_addr - $remote_user [$time_local] '
                         '"$request" $status $body_bytes_sent '
                         '"$http_referer" "$http_user_agent" $request_time';
      access_log /var/log/nginx/access.log detailed;
    '';
  };

  system.stateVersion = "23.11";
}
