{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
  cfg = config.clord.agenix;
in {
  options.clord.agenix = {
    enable = mkOption {
      default = true;
      example = true;
      type = types.bool;
    };
    secrets = mkOption {
      type = types.attrs;
      default = {};
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
    age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    age.secrets = {
      chickenpiAppSecret.file = ../secrets/chickenpiAppSecret.age;
      chickenpiConfig.file = ../secrets/chickenpiConfig.age;
      chickenpiRipCert.file = ../secrets/chickenpiRipCert.age;
      chickenpiRipKey.file = ../secrets/chickenpiRipKey.age;
      clordPasswd.file = ../secrets/clordPasswd.age;
      eugenePasswd.file = ../secrets/eugenePasswd.age;
      rootPasswd.file = ../secrets/rootPasswd.age;
    };
  };
}
