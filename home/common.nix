{ config, pkgs, ... }: {
  imports = [ ./fish.nix ];
  programs.bat.enable = true;
  programs.info.enable = true;
  programs.ssh = import ./ssh.nix;
  home.file = {
    # Just to document how to make symlinks really...
    ".homedir".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/";
  };

  home.packages = with pkgs; [
    neovim
    neovide
    basex
    hledger
    openssh
    pandoc
    proselint
    sqlite
    unzip
    wkhtmltopdf
    zip
  ];

}
