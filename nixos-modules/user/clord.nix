{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.clord.user;
  pubkeys = import ../../pubkeys;
in {
  options.clord.user = {
    enable = lib.mkEnableOption "Enables my user.";
    linuxUser = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 1000;
    };
    minimal = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
    isMac = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
    home = lib.mkOption {
      type = lib.types.path;
      default = "/home/clord";
      description = "path to user's home dir";
    };
    username = lib.mkOption {
      type = lib.types.str;
      default = "clord";
      description = "My username for this system.";
    };
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    extraAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional authorized keys";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.clord =
      (lib.mkIf cfg.minimal
        (import ../../home/clord/minimal.nix))
      // (lib.mkIf cfg.isMac
        ((import ../../home/clord/edmon.nix)
          // {
            programs.ssh = {
              enable = true;
              extraConfig = ''
                # Set up our mac-specific stuff
                # IdentityAgent /Users/clord/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
                IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
              '';
            };
          }))
      // (lib.mkIf (!cfg.minimal && !cfg.isMac)
        (import ../../home/clord));

    users.users.clord =
      {
        inherit (cfg) home;
        name = cfg.username;
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = pubkeys.clord.user ++ cfg.extraAuthorizedKeys;
      }
      // (lib.mkIf cfg.linuxUser {
        inherit (cfg) uid;
        isNormalUser = true;
        extraGroups = ["wheel"] ++ cfg.extraGroups;
        hashedPasswordFile = config.age.secrets.clordPasswd.path;
      });
    clord.agenix.secrets.clordPasswd = {};
    programs.fish.enable = true;
  };
}
