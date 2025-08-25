# Common packages for all systems (both macOS and Linux)
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Core utilities
    age
    fd
    fish
    fzf
    fzy
    ripgrep
    tree

    # Development tools
    difftastic
    git-crypt
    gnused
    jless
    jsonnet
    nixfmt-rfc-style
    openssh
    pandoc
    sqlite

    # Language support
    pyenv
    python3
    rbenv

    # File management
    dua
    ffmpeg
    ffsend
    mosh
    nq
    resvg
    sops
    sysbench
    tldr
    typst
    unzip
    vale
    wget
    xz
    zip

    # Misc tools
    basex
    bundix
    hledger
    proselint
  ];
}
