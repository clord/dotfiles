{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.eugene.user;
  pubkeys = import ../../pubkeys;
in {
  options.eugene.user = {
    enable = lib.mkEnableOption "Enables eugene user.";
    linuxUser = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 1010;
    };
    home = lib.mkOption {
      type = lib.types.path;
      default = "/home/eugene";
      description = "path to user's home dir";
    };
    username = lib.mkOption {
      type = lib.types.str;
      default = "eugene";
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
    home-manager.users.eugene = import ../../home/eugene;
    users.users.eugene =
      {
        inherit (cfg) uid home;
        name = cfg.username;
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = pubkeys.eugene.user ++ cfg.extraAuthorizedKeys;
      }
      // (lib.mkIf cfg.linuxUser {
        isNormalUser = true;
        extraGroups = ["wheel"] ++ cfg.extraGroups;
        hashedPasswordFile = config.age.secrets.clordPasswd.path;
      });
    programs.fish.enable = true;
    clord.agenix.secrets.eugenePasswd = {};
  };
}
