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
    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 1000;
    };
    isLinux = lib.mkOption {
      type = lib.types.bool;
      example = true;
      default = false;
      description = "Is this a Linux user?";
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
    users.users.clord =
      {
        inherit (cfg) home;
        name = cfg.username;
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = pubkeys.clord.user ++ cfg.extraAuthorizedKeys;
      }
      // (
        lib.mkIf cfg.isLinux {
          inherit (cfg) uid;
          isNormalUser = true;
          extraGroups = ["wheel"] ++ cfg.extraGroups;
          hashedPasswordFile = config.age.secrets.clordPasswd.path;
        }
      );

    clord.agenix.secrets.clordPasswd = {};

    programs.fish = {
      enable = true;
      loginShellInit = let
        # This naive quoting is good enough in this case. There shouldn't be any
        # double quotes in the input string, and it needs to be double quoted in case
        # it contains a space (which is unlikely!)
        dquote = str: "\"" + str + "\"";

        makeBinPathList = map (path: path + "/bin");
      in ''
        fish_add_path --move --prepend --path ${lib.concatMapStringsSep " " dquote (makeBinPathList config.environment.profiles)}
        set fish_user_paths $fish_user_paths
      '';
    };
  };
}
