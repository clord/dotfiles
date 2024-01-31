{
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkIf roles.terminal.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
    };
  };
}
