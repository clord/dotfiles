{...}: {
  imports = [
    ./darwin-common.nix
    ./modules
    ./ssh-configs/darwin-base.nix
  ];

  home = {
    username = "clord";
  };
}
