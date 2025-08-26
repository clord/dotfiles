# Security hardening configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.security;
in {
  options.modules.security = {
    enable = mkEnableOption "security hardening";

    enableSudo = mkOption {
      type = types.bool;
      default = true;
      description = "Enable sudo";
    };

    sudoWheelNeedsPassword = mkOption {
      type = types.bool;
      default = true;
      description = "Require password for sudo";
    };

    enableFaillock = mkOption {
      type = types.bool;
      default = true;
      description = "Enable account lockout after failed login attempts";
    };

    enableAppArmor = mkOption {
      type = types.bool;
      default = false;
      description = "Enable AppArmor";
    };

    enableAudit = mkOption {
      type = types.bool;
      default = false;
      description = "Enable audit framework";
    };

    sshConfig = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable SSH server";
      };

      passwordAuthentication = mkOption {
        type = types.bool;
        default = false;
        description = "Allow password authentication";
      };

      permitRootLogin = mkOption {
        type = types.enum ["yes" "no" "prohibit-password"];
        default = "prohibit-password";
        description = "Permit root login via SSH";
      };

      ports = mkOption {
        type = types.listOf types.port;
        default = [22];
        description = "SSH ports to listen on";
      };
    };
  };

  config = mkIf cfg.enable {
    # Security settings
    security = {
      sudo = {
        enable = cfg.enableSudo;
        wheelNeedsPassword = cfg.sudoWheelNeedsPassword;
        extraRules = [
          {
            groups = ["wheel"];
            commands = [
              {
                command = "${pkgs.systemd}/bin/systemctl";
                options = ["NOPASSWD"];
              }
              {
                command = "${pkgs.nix}/bin/nix-collect-garbage";
                options = ["NOPASSWD"];
              }
            ];
          }
        ];
      };

      # Kernel hardening
      protectKernelImage = true;
      lockKernelModules = false; # Set to true for production

      # AppArmor
      apparmor = {
        enable = cfg.enableAppArmor;
        killUnconfinedConfinables = cfg.enableAppArmor;
      };

      # Audit
      audit = {
        enable = cfg.enableAudit;
        rules = lib.optionals cfg.enableAudit [
          "-w /etc/passwd -p wa -k passwd_changes"
          "-w /etc/shadow -p wa -k shadow_changes"
          "-w /etc/group -p wa -k group_changes"
        ];
      };

      # PAM configuration
      pam.services = {
        login.faillock.enable = cfg.enableFaillock;
        sshd.faillock.enable = cfg.enableFaillock;
        sudo.faillock.enable = cfg.enableFaillock;
      };
    };

    # SSH configuration
    services.openssh = mkIf cfg.sshConfig.enable {
      enable = true;
      ports = cfg.sshConfig.ports;
      settings = {
        PasswordAuthentication = cfg.sshConfig.passwordAuthentication;
        PermitRootLogin = cfg.sshConfig.permitRootLogin;
        KbdInteractiveAuthentication = false;

        # Security hardening
        X11Forwarding = false;
        StrictModes = true;
        IgnoreRhosts = true;
        HostbasedAuthentication = false;

        # Crypto settings
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
        ];

        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];

        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
        ];
      };

      extraConfig = ''
        # Additional hardening
        ClientAliveInterval 300
        ClientAliveCountMax 2
        MaxAuthTries 3
        MaxSessions 10
        TCPKeepAlive no
        Compression no
        AllowAgentForwarding no
        AllowTcpForwarding no
      '';
    };

    # Security-related packages
    environment.systemPackages = with pkgs; [
      fail2ban
      aide
      rkhunter
      lynis
    ];
  };
}