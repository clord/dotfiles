{roles, ...}: {
  programs.btop = {
    inherit (roles.terminal) enable;
    settings = {
      color_theme = "Default";
      theme_background = false;
    };
  };
}
