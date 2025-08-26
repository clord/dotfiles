{ ... }:
{
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
    ./atuin.nix
  ];
  config = {
    programs.neovim.enable = true;

    programs.bun.enable = true;

    home = {
      sessionPath = [
        "node_modules/.bin"
        "$HOME/.claude/local"
        "$HOME/.local/node_modules/.bin"
        "$HOME/go/bin"
      ];
      sessionVariables = {
        EDITOR = "nvim";
      };
    };
  };
}
