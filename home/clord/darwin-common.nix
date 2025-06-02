{pkgs, ...}: {
  imports = [./common.nix ./programs];

  home.packages = with pkgs; [
    fish
    fzf
    fzy
    gnused
    jless
    jsonnet
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
    k3d
    tilt
    kubernetes-helm
    kind
    nodePackages.svgo
  ];
}
