{roles, ...}: {
  programs.ssh = {
    inherit (roles.terminal) enable;
  };
}
