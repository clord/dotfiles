{ config, lib, pkgs, modulesPath, ... }: {

  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dunbar";
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "clord";
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/04793b4d-85f3-4ccc-91da-a746d9b1b359";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/20BC-B3BE";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}

