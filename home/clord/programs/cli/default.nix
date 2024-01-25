{ pkgs, ... }: {
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
  home.packages = with pkgs; [
age
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
  ];
  };

}

