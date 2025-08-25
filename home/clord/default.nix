_: {
  imports = [
    ./common.nix
    ./packages/linux.nix
    ./programs
  ];
  programs.fish.enable = true;
}
