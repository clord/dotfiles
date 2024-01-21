{ config, pkgs, ... }: {

  imports = [ ./common.nix ./fish.nix ./git.nix ./programs ];

  home.username = "clord";
  home.homeDirectory = "/Users/clord";

  programs.direnv = { enable = true; };
  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
    git = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      # IdentityAgent /Users/clord/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };

  home.packages = with pkgs; [
    age
    basex
    bundix
    difftastic
    dua
    fd
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

