{roles, ...}: {
  programs.kitty = {
    inherit (roles.terminal) enable;
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "BerkeleyMono Nerd Font";
      size = 14;
    };
    settings = {
      remember_window_size = true;
      initial_window_width = 100;
      initial_window_height = 30;
      hide_window_decorations = "titlebar-only";
      window_margin_width = 4;
      draw_minimal_borders = true;
    };
  };
}
