{
  pkgs,
  ...
}:
{
  imports = [ ./darwin-common.nix ];

  services.nix-daemon.enable = true;
  system.stateVersion = 5;
  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;
    settings = {
      trusted-users = [
        "@admin"
        "clord"
      ];
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      log-lines = 50;
      warn-dirty = false;
      http-connections = 50;
    };
  };

}
