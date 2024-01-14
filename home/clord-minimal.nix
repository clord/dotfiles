{ config, pkgs, ... }: {
  imports = [ ./common.nix ./fish.nix ./git.nix ];

  home.username = "clord";
  home.homeDirectory = "/home/clord";

  home.file = {
    # Just to document how to make symlinks really...
    # ".homedir".source =
    #  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/";
  };

  # Temporary workaround for rycee.net being down
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;


  home.packages = with pkgs; [
    age
    direnv
    eza
    fd
    fish
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
