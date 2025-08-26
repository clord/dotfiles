{
  lib,
  pkgs,
  roles,
  ...
}: {
  imports = [
    ../programs/cli/nvim
    ../programs/cli/helix.nix
  ];

  config = lib.mkIf roles.terminal.enable {
    home.packages = with pkgs; [
      # Editors (neovim is configured via programs.neovim)
      vim
      nano

      # Editor support tools
      editorconfig-core-c

      # Language servers and formatters
      nixd
      nil
      alejandra
      nixfmt-rfc-style
      statix
      deadnix

      # General formatters
      nodePackages.prettier
      shfmt

      # Linters
      shellcheck
      yamllint
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
    };

    # Global editorconfig
    home.file.".editorconfig".text = ''
      # EditorConfig is awesome: https://EditorConfig.org
      root = true

      [*]
      charset = utf-8
      end_of_line = lf
      insert_final_newline = true
      trim_trailing_whitespace = true
      indent_style = space
      indent_size = 2

      [*.{py,rs}]
      indent_size = 4

      [*.go]
      indent_style = tab

      [*.md]
      trim_trailing_whitespace = false

      [Makefile]
      indent_style = tab
    '';
  };
}
