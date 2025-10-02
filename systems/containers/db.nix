{pkgs, ...}: {
  services.openssh.enable = true;

  # Restrict access to internal network only
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 5432]; # SSH and PostgreSQL
    extraCommands = ''
      # Allow connections only from proxy and host
      iptables -A INPUT -s 10.68.3.1/32 -j ACCEPT
      iptables -A INPUT -s 10.68.3.2/32 -j ACCEPT
      iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -j DROP
    '';
  };

  environment.systemPackages = with pkgs; [
    postgresql
    gzip
  ];

  services = {
    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            md5
        host    all             all             ::1/128                 md5
        host    all             all             10.68.3.0/24            md5
      '';
      settings = {
        max_connections = 100;
        shared_buffers = "128MB";
        work_mem = "4MB";
        maintenance_work_mem = "64MB";
        effective_cache_size = "512MB";
      };
      dataDir = "/data/postgres";
      ensureDatabases = [
        "homeauth"
        "lectures"
      ];
      ensureUsers = [
        {
          name = "homeauth";
          ensureDBOwnership = true;
        }
        {
          name = "lectures";
          ensureDBOwnership = true;
        }
      ];
    };

    # Daily database backups
    cron = {
      enable = true;
      systemCronJobs = [
        "0 3 * * * root mkdir -p /data/backups && pg_dump -U postgres -F c -Z 9 -f /data/backups/all_$(date +\\%Y\\%m\\%d).psql.gz postgres && find /data/backups -type f -name '*.psql.gz' -mtime +14 -delete"
      ];
    };
  };

  system.stateVersion = "23.11";
}
