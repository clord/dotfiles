{ config, pkgs, ... }: {
  imports = [ ./common.nix ./fish.nix ./git.nix ];

  home.username = "clord";
  home.homeDirectory = "/home/clord";

  home.file = {
    # Just to document how to make symlinks really...
    ".homedir".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/";
  };

  # Temporary workaround for rycee.net being down
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;

  home.packages = with pkgs; [
    age
    basex
    bundix
    difftastic
    direnv
    dua
    eza
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
    xz
    zip
  ];

}
