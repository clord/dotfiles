{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./ssh.nix
    ./btop.nix
    ./direnv.nix
    ./helix.nix
    ./nvim
    ./eza.nix
    ./fish.nix
    ./git.nix
  ];
  config = {
    home = {
      sessionPath = ["node_modules/.bin"];
      sessionVariables = {
        EDITOR = "nvim";
      };
      packages = with pkgs; [
        age
        nodejs
        basex
        bundix
        difftastic
        fd
        ffmpeg
        fzf
        fzy
        mosh
        nixfmt
        pandoc
        typst
        tldr
        sysbench
        sqlite
        unzip
        vale
        wget
        xz
        zip
        nodePackages.yarn
      ];
    };
  };
}
