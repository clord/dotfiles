{ config, lib, pkgs, ... }:
let
  cfg = config.clord.user;
  pubkeys = import ../../pubkeys/default.nix;

in {
  options.clord.user = {
    enable = lib.mkEnableOption "Enables my user.";
    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 1000;
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

    users.users.clord = {
      isNormalUser = true;
      uid = cfg.uid;
      home = cfg.home;
      shell = pkgs.fish;
      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
      openssh.authorizedKeys.keys = pubkeys.clord.user ++ cfg.extraAuthorizedKeys;
      hashedPasswordFile = config.age.secrets.clordPasswd.path;
    };
    programs.fish.enable = true;
    clord.agenix.secrets.clordPasswd = { };
  };
}
