{pkgs, ...}: {
  imports = [./common.nix ./programs];

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    vscode.enable = true;
    alacritty = {
      enable = true;
      settings = {font.size = 14;};
    };
    firefox.enable = true;
    git.enable = true;
    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
  };
  home.packages = with pkgs; [
    alsa-utils
    audacity
    discord
    dmenu
    dolphin
    typst
    typst-lsp
    go
    hledger
    godot_4
    element-desktop
    exfat
    eza
    fd
    feh
    floorp
    gcc
    gnome.nautilus
    gnumake
    htop
    jdk17
    killall
    konsole
    libreoffice
    matrix-commander
    networkmanagerapplet
    nitrogen
    obs-studio
    plex-media-player
    prismlauncher
    python311Full
    racket
    steam
    terminator
    trayer
    xfce.xfce4-power-manager
    xscreensaver
    yad
    zlib
  ];

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [hp.dbus hp.monad-logger hp.xmonad-contrib];
      config = ./xmonad.hs;
    };
  };

  systemd.user.startServices = "sd-switch";
}
