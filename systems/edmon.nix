{
  pkgs,
  ...
}:
{
  # Auto upgrade nix package and the daemon service.
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

  system.defaults = {
    dock = {
      autohide = false;
      orientation = "left";
      show-process-indicators = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      "com.apple.keyboard.fnState" = false;
    };
  };

  environment.systemPackages = with pkgs; [
    fish
    vim
    git
    home-manager
    devenv
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
