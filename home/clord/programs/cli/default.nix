{ pkgs, ... }: {
  imports = [ ./bat.nix ./btop.nix ./direnv.nix ./helix.nix ./nvim ];
  programs.nix-index.enable = true;
}

