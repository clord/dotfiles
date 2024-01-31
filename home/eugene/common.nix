{
  config,
  pkgs,
  ...
}: {
  imports = [];
  home.stateVersion = "23.11";
  programs.bat.enable = true;
  programs.ssh = import ./ssh.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [];
}
