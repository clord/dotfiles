# NixOS modules - works on both NixOS and Darwin where applicable
{ lib, pkgs, ... }:
{
  imports = [
    ./agenix.nix  # Works on both platforms
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux/NixOS-only modules
    ./user/default.nix
    ./linux-only
  ];
}
