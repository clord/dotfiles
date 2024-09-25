{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # 
  system.stateVersion = 5;
  nix = {
    registry = {
      nixpkgs = {flake = inputs.nixpkgs;};
    };
    package = pkgs.nix;
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "/nix/var/nix/profiles/per-user/root/channels"
      "nixpkgs=${config.nix.registry.nixpkgs.to.path}"
    ];
    configureBuildUsers = true;

    settings = { 
      trusted-users = ["@admin" "clord"];

        experimental-features = [
          "flakes"
          "nix-command"
        ];

        log-lines = 50;
        warn-dirty = false;
        http-connections = 50;
    };

  };

  environment.systemPackages = with pkgs; [fish nushell vim git devenv];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
