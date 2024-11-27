{ config, roles, pkgs, ... }:
{
  programs.atuin = {  
    enable = roles.terminal.enable;
    enableFishIntegration = roles.terminal.enable;
    settings = {
      style = "compact";
      enter_accept = false;
      inline_height = 40;
    };
  };

}
