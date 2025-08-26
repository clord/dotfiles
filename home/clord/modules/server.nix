# Server and infrastructure tools
{
  config,
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkIf (roles.server.enable or false) {
    home.packages = with pkgs; [
      # Web servers
      caddy
      nginx

      # Log processing and analysis
      angle-grinder # Log analysis tool

      # Database tools
      redis

      # Container tools (if not already enabled via other roles)
      docker-compose

      # Network tools
      nmap
      iperf3

      # SSL/TLS tools
      certbot
      mkcert

      # Backup tools
      restic
      borgbackup
    ];

    # Server-related aliases
    programs.fish.shellAbbrs = lib.mkIf config.programs.fish.enable {
      caddyrun = "caddy run --config Caddyfile";
      caddyfmt = "caddy fmt --overwrite";
      agr = "angle-grinder";
      logs = "lnav";
    };
  };
}
