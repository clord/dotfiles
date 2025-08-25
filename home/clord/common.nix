{pkgs, ...}: {
  imports = [
    ./packages/common.nix
  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion = "24.05";
  };
}
