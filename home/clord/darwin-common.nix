{pkgs, ...}: {
  imports = [
    ./common.nix
    ./packages/darwin.nix
    ./programs
  ];
}
