{ config, pkgs, ... }: {
  imports = [ ./common.nix ./fish.nix ./git.nix ];

  home.username = "clord";
  home.homeDirectory = "/Users/clord";

}


