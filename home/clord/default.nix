{pkgs, ...}: {
  imports = [./common.nix ./programs];

  home.packages = with pkgs; [
    age
    difftastic
    git
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
    nushell
    fish
    fzf
    fzy
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
