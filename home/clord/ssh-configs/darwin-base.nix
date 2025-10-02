# Base SSH configuration for all macOS systems
_: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      # Use 1Password SSH agent on macOS
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}
