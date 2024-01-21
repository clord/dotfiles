{ config, lib, pkgs, ... }:
let
  cfg = config.eugene.user;
  pubkeys = import ../../pubkeys/default.nix;

in {
  options.eugene.user = {
    enable = lib.mkEnableOption "Enables eugene user.";
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
      default = [ ];
    };
    extraAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional authorized keys";
    };
  };

  config = lib.mkIf cfg.enable {
    # Let ~/bin/ be in $PATH
    # environment.homeBinInPath = true;

    users.users.eugene = {
      isNormalUser = true;
      uid = cfg.uid;
      home = cfg.home;
      shell = pkgs.fish;
      extraGroups = [ "family" ] ++ cfg.extraGroups;
      openssh.authorizedKeys.keys = pubkeys.eugene.user ++ cfg.extraAuthorizedKeys;
      hashedPasswordFile = config.age.secrets.eugenePasswd.path;
    };
    programs.fish.enable = true;
    clord.agenix.secrets.eugenePasswd = { };
  };
}
