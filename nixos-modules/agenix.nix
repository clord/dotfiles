{ options, config, inputs, lib, pkgs, ... }:
with builtins;
with lib;
let
  secretsDir = "${toString ../../secrets}";
  secretsFile = "${secretsDir}/secrets.nix";
  cfg = config.clord.agenix;
in {
  options.clord.agenix = {
    enable = mkBoolOpt true;
    secrets = mkOption {
      type = types.attrs;
      default = { };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];
    users.users.root.hashedPasswordFile = config.age.secrets.rootPasswd.path;
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets =
      mapAttrs (name: obj: ({ file = "${secretsDir}/${name}.age"; } // obj)) (cfg.secrets // { rootPasswd = { }; });
    assertions = [{
      assertion = (pathExists secretsFile);
      message = "${secretsFile} does not exist";
    }];
  };
}
