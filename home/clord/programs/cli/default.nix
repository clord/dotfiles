{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./kitty.nix
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

    programs.neovim.enable = true;
    home = {
      sessionPath = ["node_modules/.bin" "$HOME/go/bin"];
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
        git
        go
        mosh
        nixfmt
        angle-grinder
        nodejs_22
        corepack_22
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
