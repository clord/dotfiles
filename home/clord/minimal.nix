{pkgs, ...}: {
  imports = [
    ./common.nix
    ./modules # Use modular configuration even for minimal
  ];
  home = {
    username = "clord";
    homeDirectory = "/home/clord";

    # Minimal system overrides - keep only essentials
    packages = with pkgs; [
      # These override the modular packages for a minimal install
      openssh
      wget
      git
      vim
    ];
  };
}
