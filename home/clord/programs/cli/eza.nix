{roles, ...}: {
  programs.eza = {
    inherit (roles.terminal) enable;
    icons = "auto";
    git = true;
  };
}
