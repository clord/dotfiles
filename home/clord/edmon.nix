{...}: {
  imports = [
    ./darwin-common.nix
    ./modules
  ];

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
}
