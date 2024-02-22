{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./git.nix
    ./helix.nix
    ./nvim
    ./ssh.nix
  ];
  config = {
    home = {
      sessionPath = ["node_modules/.bin"];
      sessionVariables = {
        EDITOR = "nvim";
      };
      packages = with pkgs; [
        age
        difftastic
        fd
        ffmpeg
        fzf
        go
        mosh
        nixfmt
        nodePackages.yarn
        nodejs
        pandoc
        python311Packages.pynvim
        sqlite
        sysbench
        tldr
        typst
        unzip
        wget
        xz
        zig
        zip
      ];
    };
  };
}
