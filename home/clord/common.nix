{pkgs, ...}: {
  imports = [];
 programs.home-manager.enable = true;
 home.stateVersion = "24.05";
 home.packages = with pkgs; [
    age
    basex
    bundix
    difftastic
    dua
    fd
    fish
    ffmpeg
    ffsend
    fzf
    fzy
    git-crypt
    gnused
    hledger
    jless
    jsonnet
    mosh
    nixfmt-rfc-style
    nq
    openssh
    pandoc
    proselint
    pyenv
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
