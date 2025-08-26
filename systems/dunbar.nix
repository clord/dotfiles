{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
  };
  networking = {
    hostName = "dunbar";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  nixpkgs.config.allowUnfree = true;
  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "clord";
    };

    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  users.users.root.hashedPasswordFile = config.age.secrets.rootPasswd.path;

  # Enable sound with pipewire.
  # sound.enable is deprecated, configured via pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/04793b4d-85f3-4ccc-91da-a746d9b1b359";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/20BC-B3BE";
    fsType = "vfat";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # This value determines the NixOS release with which your system is to be
  # compatible. Read the release notes before changing.
  system.stateVersion = "24.11";
}
