{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./nushell.nix
    ./git.nix
    ./helix.nix
    ./nvim
    ./ssh.nix
  ];
  config = {
    home = {
      sessionPath = ["node_modules/.bin" "~/.go/bin"];
      sessionVariables = {
        EDITOR = "nvim";
      };
      packages = with pkgs; [
        age
        dua
        difftastic
        fd
        ffmpeg
        hledger
        fzf
        nixfmt
        git
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
