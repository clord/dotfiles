_: {
  imports = [];
  home.stateVersion = "24.05";
  programs = {
    bat.enable = true;
    ssh = import ./ssh.nix;
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
