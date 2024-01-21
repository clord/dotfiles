{ roles, lib, pkgs, config, ... }: {
  config = lib.mkIf roles.terminal.enable {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim;
      defaultEditor = true;
      extraPackages = with pkgs; [
        black
        cmake
        fzf
        gcc
        gnumake
        isort
        lua-language-server
        nixd
        nodejs
        prettierd
        ripgrep
        rust-analyzer
        shfmt
        sqlfluff
        sqlite
        stylua
      ];
      plugins = with pkgs.vimPlugins; [
        lazy-nvim
        vim-autoswap
      ];
    };
    xdg.configFile = { };
  };
}
