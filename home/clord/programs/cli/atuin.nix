{roles, pkgs, ...}: {
  programs.atuin = {
    inherit (roles.terminal) enable;
    package = pkgs.atuin;
    flags = ["--disable-up-arrow"];
    enableFishIntegration = roles.terminal.enable;
    settings = {
      style = "compact";
      enter_accept = false;
      inline_height = 40;
    };
  };
}
