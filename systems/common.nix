{ config, pkgs, ... }: {

  imports = [ ./locale.nix ];

  system = {
    # Did you read the comment?
    stateVersion = "23.11";
  };
  services.timesyncd.enable = true;
  environment.systemPackages = [ pkgs.git pkgs.vim pkgs.home-manager ];

  programs.nix-index.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      max-jobs = 4;
      cores = 4;
      trusted-users = [ "root" "clord" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };

    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = "  min-free = ${toString (100 * 1024 * 1024)}\n  max-free = ${
          toString (1024 * 1024 * 1024)
        }\n  keep-outputs = true\n  keep-derivations = true\n";
  };

}

