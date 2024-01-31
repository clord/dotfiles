{roles, ...}: {
  programs.direnv = {
    inherit (roles.terminal) enable;
    nix-direnv.enable = true;
    config = {
      load_dotenv = true;
      strict_env = true;
      warn_timeout = 10;
      disable_stdin = true;
    };
  };
}
