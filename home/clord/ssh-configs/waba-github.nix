# Waba-specific SSH configuration for GitHub (personal + Grafana)
_: {
  programs.ssh.extraConfig = ''
    # Personal GitHub
    Host personal.github.com
      User git
      HostName github.com
      IdentityFile ~/.ssh/personal_git.pub
      IdentitiesOnly yes

    # Grafana GitHub
    Host grafana.github.com
      User git
      HostName github.com
      IdentityFile ~/.ssh/grafana_git.pub
      IdentitiesOnly yes
  '';
}
