{ config, pkgs, ... }: {
  imports = [ ./common.nix ];

  home.username = "clord";
  home.homeDirectory = "/home/clord";

  home.packages = with pkgs; [ age direnv eza fd fish nixfmt openssh ripgrep sops sqlite tree unzip wget xz zip ];

}
