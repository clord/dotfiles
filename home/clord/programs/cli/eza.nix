{roles, ...}: {
  programs.eza = {
    inherit (roles.terminal) enable;
    enableFishIntegration = roles.terminal.enable;
    icons = "auto";
    git = true;
  };
}
