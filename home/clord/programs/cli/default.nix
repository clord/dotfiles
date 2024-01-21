{ pkgs, ... }: {
  imports = [ ./bat.nix ./btop.nix ./nvim ];
  programs.nix-index.enable = true;
}

