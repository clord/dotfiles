{
  config,
  pkgs,
  ...
}: {
  services.openssh.enable = true;

  # Restrict access to internal network only
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      3000
      9090
      9100
    ]; # SSH, Grafana, Prometheus, Node exporter
    extraCommands = ''
      # Allow connections only from proxy and host
      iptables -A INPUT -s 10.68.3.1/32 -j ACCEPT
      iptables -A INPUT -s 10.68.3.2/32 -j ACCEPT
      iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -j DROP
    '';
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
        domain = "grafana.local";
        root_url = "https://grafana.local/";
      };
      security = {
        # Add more security configurations as needed
        allow_embedding = false;
      };
    };
  };

  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
      };
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["localhost:9100"];
          }
        ];
      }
      {
        job_name = "jasper";
        static_configs = [
          {
            targets = ["10.68.3.2:9100"];
          }
        ];
      }
    ];
  };

  system.stateVersion = "23.11";
}
