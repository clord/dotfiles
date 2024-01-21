{ roles, lib, ... }: {
  config = lib.mkIf roles.terminal.enable {
    programs.helix = {
      enable = true;
      settings = { };
    };
  };
}
