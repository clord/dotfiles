{ config, pkgs, ... }: {
  imports = [ ./common.nix ./fish.nix ./git.nix ./programs ];

  home.sessionVariables = { };

  home.packages = with pkgs; [
    age
    basex
    bundix
    difftastic
    gcc
    gnumake
    nodejs
    eza
    direnv
    go
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
