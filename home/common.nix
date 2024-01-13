{ config, pkgs, ... }: {
  imports = [ ];
  home.stateVersion = "23.11";
  programs.bat.enable = true;
  programs.ssh = import ./ssh.nix;

  # Temporary workaround for rycee.net being down
  home.manual.html.enable = false;
  home.manual.manpages.enable = false;
  home.manual.json.enable = false;

  home.packages = with pkgs; [
  ];

}
