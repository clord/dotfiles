{config, lib, pkgs, modulesPath, ...}: {
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  networking.hostName = "dunbar";
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}

