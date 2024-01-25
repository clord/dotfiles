_: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    settings.trusted-users = ["@admin" "clord"];
    configureBuildUsers = true;

    # Necessary for using flakes on this system.
    settings.experimental-features = "nix-command flakes";
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
