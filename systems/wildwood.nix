{ config, pkgs, lib, ... }: {
  hardware.enableRedistributableFirmware = true;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/11358208-4b78-48e3-9d99-3646decc498d";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-461210a1-9972-4edb-9d09-969785bf51b6".device =
    "/dev/disk/by-uuid/461210a1-9972-4edb-9d09-969785bf51b6";

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/E100-34B0";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/d32f9711-d667-4191-ada4-42889f0f1539"; }];

  # Enable swap on luks
  boot.initrd.luks.devices."luks-124a19d0-de3d-4b28-8c69-cb56b7905426".device =
    "/dev/disk/by-uuid/124a19d0-de3d-4b28-8c69-cb56b7905426";
  boot.initrd.luks.devices."luks-124a19d0-de3d-4b28-8c69-cb56b7905426".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "wildwood";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
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

  users.users.eugene = {
    isNormalUser = true;
    description = "Eugene Lord";
    extraGroups = [ "networkmanager" ];
  };

  home-manager.users.eugene = { pkgs, ... }: {
    home.stateVersion = "22.11";
    home.packages = with pkgs; [ firefox neovim ];
    programs.fish.enable = true;
  };

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
