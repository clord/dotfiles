{ lib, ... }: {
  options = {
    roles.terminal.enable = lib.mkEnableOption "Enable terminal";
  };
  config = { };
}
