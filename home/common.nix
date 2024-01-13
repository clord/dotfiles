{ config, pkgs, ... }: {
  imports = [ ./fish.nix  ./git.nix ];
  stateVersion = "23.11";
  programs.bat.enable = true;
  programs.info.enable = true;
  programs.ssh = import ./ssh.nix;

  home.file = {
    # Just to document how to make symlinks really...
    ".homedir".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/";
  };

  home.packages = with pkgs; [
    age
    basex
    bundix
    difftastic
    direnv
    dua
    exa
    fd
    ffmpeg
    ffsend
    fish
    fzf
    fzy
    git-crypt
    gnused
    hledger
    imgcat
    jless
    jsonnet
    lima
    luarocks
    mosh
    neovim
    nixfmt
    nq
    openssh
    pandoc
    pandoc
    pnpm
    proselint
    pyenv
    python3
    rbenv
    resvg
    ripgrep
    sops
    sqlite
    sysbench
    terraform
    tldr
    tree
    typst
    unzip
    vale
    wget
    wkhtmltopdf
    xz
    zip
  ];

}
