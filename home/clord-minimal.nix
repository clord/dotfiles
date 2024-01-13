{ config, pkgs, ... }: {
  imports = [ ./common.nix ./fish.nix ./git.nix ];

  home.file = {
    # Just to document how to make symlinks really...
    ".homedir".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/";
  };

  home.packages = with pkgs; [
    age
    direnv
    eza
    fd
    fish
    mosh
    neovim
    nixfmt
    openssh
    ripgrep
    sops
    sqlite
    tree
    unzip
    wget
    xz
    zip
  ];

}
