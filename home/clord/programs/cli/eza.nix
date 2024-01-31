{roles, ...}: {
  programs.eza = {
    enable = roles.terminal.enable;
    enableAliases = true;
    icons = true;
    git = true;
  };
}
