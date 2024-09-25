{pkgs, ...}: {
  imports = [./common.nix ./programs];

  home = {
    username = "clord";
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      # Set up our mac-specific stuff
      # IdentityAgent /Users/clord/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };

  home.packages = with pkgs; [
    fish
    fzf
    fzy
    gnused
    jless
    jsonnet
    nq
    openssh
    pandoc
    proselint
    pyenv
    python3
    rbenv
    resvg
    ripgrep
    sops
    sqlite
    sysbench
    tldr
    tree
    typst
    unzip
    vale
    wget
    xz
    zip
    k3d
    tilt
    kubernetes-helm
    kind
    nodePackages.svgo
  ];
}
