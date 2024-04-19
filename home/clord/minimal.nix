{pkgs, ...}: {
  imports = [./common.nix];
  home = {
    username = "clord";
    homeDirectory = "/home/clord";

    packages = with pkgs; [age direnv eza fd fish sqlite nushell nixfmt openssh ripgrep sops sqlite tree unzip wget xz zip];
  };
}
