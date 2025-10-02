# Common packages for all systems (both macOS and Linux)
# NOTE: This should only contain truly universal CLI utilities.
# Role-specific packages should be in home/clord/modules/*.nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Core utilities - universally useful
    age
    fd
    fish
    fzf
    fzy
    ripgrep
    tree

    # Network utilities
    gnused
    mosh
    openssh
    wget

    # File management
    dua
    ffmpeg
    ffsend
    unzip
    xz
    zip

    # Documentation/writing
    jless
    tldr
    vale
    proselint

    # Security/secrets
    sops

    # Specialized utilities (review these later)
    nq
    resvg
    basex
    hledger

    # Removed duplicates (now in role modules):
    # - difftastic, git-crypt, sqlite, pandoc -> modules/development.nix
    # - jsonnet -> modules/grafana.nix
    # - python3, pyenv -> modules/development.nix
    # - rbenv, bundix, nixfmt-rfc-style, sysbench, typst -> to be moved to development module
  ];
}
