{roles, ...}: {
  programs.eza = {
    enable = roles.terminal.enable;
    icons = "auto";
    git = true;
  };
}
