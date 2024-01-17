{ config, pkgs, ... }: {
  imports = [ ./common.nix ./fish.nix ./git.nix ];

  # home.username = "clord";
  # home.homeDirectory = "/home/clord";

  #home.file = {
  # Just to document how to make symlinks really...
  #".homedir".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/";
  #};

  # Temporary workaround for rycee.net being down
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;

  xdg.configFile.nvim.source = ./nvim;

  home.packages = with pkgs; [
    age
    basex
    bundix
    difftastic
    eza
    direnv
    dua
    fd
    ffmpeg
    ffsend
    fish
    fzf
    fzy
    git-crypt
    gnused
    hledger
    jless
    jsonnet
    mosh
    neovim
    nixfmt
    nq
    openssh
    pandoc
    proselint
    python3
    rbenv
    resvg
    ripgrep
    sops
    sqlite
    sysbench
    tldr
    tree
    typst
    unzip
    vale
    wget
    xz
    zip
  ];

}
