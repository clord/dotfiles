{ config, pkgs, ... }: {
  imports = [ ];
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [ ];
}
