_: {
  imports = [
    ./common.nix
    ./packages/linux.nix
    ./modules # Use modular configuration
    ./programs
  ];
  programs.fish.enable = true;
}
