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
      window_margin_width = 4;
    };
  };
}
