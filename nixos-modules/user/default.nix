{ config, lib, pkgs, ... }:
let
  cfg = config.clord.user;
  uid = cfg.uid;
  username = cfg.username;
  extraGroups = cfg.extraGroups;
  extraAuthorizedKeys = cfg.extraAuthorizedKeys;
  pubkeys = import ../../pubkeys/default.nix;

in
{
  options.clord.user = {
    enable = lib.mkEnableOption "Enables my user.";
    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 1000;
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
    environment.homeBinInPath = true;

    # Define my user account
    users.extraUsers.${username} = {
      isNormalUser = true;
      uid = uid;
      extraGroups = [ "wheel" ] ++ extraGroups;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = pubkeys.clord.user ++ extraAuthorizedKeys;
      hashedPasswordFile = config.age.secrets.clordPasswd.path;
    };
    clord.agenix.secrets.clordPasswd = { };

  };
}
