{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.root.hashedPasswordFile = config.age.secrets.rootPasswd.path;
  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    pulseaudio.enable = false;
  };
  boot = {
    initrd = {
      kernelModules = [];

      availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];

      # Setup keyfile
      secrets = {"/crypto_keyfile.bin" = null;};
      luks = {
        devices = {
          "luks-461210a1-9972-4edb-9d09-969785bf51b6".device = "/dev/disk/by-uuid/461210a1-9972-4edb-9d09-969785bf51b6";

          # Enable swap on luks
          "luks-124a19d0-de3d-4b28-8c69-cb56b7905426".device = "/dev/disk/by-uuid/124a19d0-de3d-4b28-8c69-cb56b7905426";
          "luks-124a19d0-de3d-4b28-8c69-cb56b7905426".keyFile = "/crypto_keyfile.bin";
        };
      };
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/11358208-4b78-48e3-9d99-3646decc498d";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/E100-34B0";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/d32f9711-d667-4191-ada4-42889f0f1539";}];
  networking = {
    hostName = "wildwood";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11

      layout = "us";
      xkbVariant = "";
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

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    linux-firmware
    networkmanager
    linuxKernel.packages.linux_zen.system76
    system76-firmware
    linuxKernel.packages.linux_zen.system76-power
    libz
    pciutils
    gnumake
  ];
}
