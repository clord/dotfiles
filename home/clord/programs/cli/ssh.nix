{roles, ...}: {
  programs.ssh = {
    inherit (roles.terminal) enable;
    extraConfig = ''
      # IdentityAgent /Users/clord/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}
