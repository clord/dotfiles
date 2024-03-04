{
  pkgs,
  inputs,
  devenv,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    registry = {
      nixpkgs = {flake = inputs.nixpkgs;};
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
    settings.trusted-users = ["@admin" "clord"];
    configureBuildUsers = true;

    # Necessary for using flakes on this system.
    settings.experimental-features = "nix-command flakes";
  };

  environment.systemPackages = [devenv] ++ (with pkgs; [fish nushell vim git]);

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
