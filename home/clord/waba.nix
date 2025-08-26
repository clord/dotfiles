_: {
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
           IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
           Host personal.github.com
             User git
      HostName github.com
      IdentityFile ~/.ssh/personal_git.pub
      IdentitiesOnly yes
           Host grafana.github.com
             User git
      HostName github.com
      IdentityFile ~/.ssh/grafana_git.pub
      IdentitiesOnly yes
    '';
  };
}
