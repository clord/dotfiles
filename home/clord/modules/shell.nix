{
  lib,
  pkgs,
  roles,
  ...
}:
{
  imports = [
    ../programs/cli/fish.nix
    ../programs/cli/nushell.nix
    ../programs/cli/direnv.nix
    ../programs/cli/atuin.nix
  ];

  config = lib.mkIf roles.terminal.enable {
    home.packages = with pkgs; [
      # Shell utilities
      fish
      zsh
      bash

      # File navigation
      fd
      fzf
      fzy
      ripgrep
      tree

      # System monitoring
      btop
      htop

      # File management
      dua
      ncdu

      # Text processing
      jq
      yq

      # Network tools
      curl
      wget
      mosh
      openssh

      # Archive tools
      unzip
      zip
      xz

      # Misc utilities
      tldr
      age
      sops
    ];
  };
}
