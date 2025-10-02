_: {
  imports = [
    ./darwin-common.nix
    ./modules
    ./ssh-configs/darwin-base.nix
    ./ssh-configs/waba-github.nix
  ];

  home = {
    username = "clord";
  };
}
