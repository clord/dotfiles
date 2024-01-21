{ inputs, lib, config, pkgs, ... }: {
  imports = [ ./common.nix ./programs ];

  programs.neovim.enable = true;
  programs.vscode = { enable = true; };
  home.packages = with pkgs; [
    alacritty
    alsa-utils
    audacity
    discord
    dmenu
    dolphin
    typst
    typst-lsp
    vscode
    go
    hledger
    godot_4
    element-desktop
    exfat
    eza
    fd
    feh
    firefox
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
      extraPackages = hp: [ hp.dbus hp.monad-logger hp.xmonad-contrib ];
      config = ./xmonad.hs;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = { font.size = 14; };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
  };
  systemd.user.startServices = "sd-switch";
}
