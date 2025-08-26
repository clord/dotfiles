{
  config,
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkIf roles.grafana.enable {
    home.packages = with pkgs;
      [
        # Grafana tools
        jsonnet
        jsonnet-bundler
        tanka

        # Testing tools
        k6

        # Act for GitHub Actions testing
        act
      ]
      ++ (lib.optionals roles.grafana.includeCloud [
        # Grafana Cloud specific tools would go here
        google-cloud-sdk
      ]);

    programs.git.includes = lib.mkIf config.programs.git.enable [
      {
        condition = "hasconfig:remote.*.url:git@*github.com:grafana/**";
        contents = {
          user = {
            name = "Christopher Lord";
            email = "christopher.lord@grafana.com";
          };
        };
      }
    ];

    home.sessionVariables = {
      GRAFANA_HOME = "$HOME/src/grafana";
    };

    programs.fish.shellAbbrs = lib.mkIf config.programs.fish.enable {
      gf = "cd $GRAFANA_HOME";
      gfb = "mage build";
      gfr = "mage run";
      gft = "mage test";
      tk = "tk";
      jb = "jb";
    };

    # Grafana-specific git configuration
    home.file.".config/grafana/config.ini".text = ''
      # Local Grafana development config
      [server]
      http_port = 3000

      [database]
      type = sqlite3

      [auth.anonymous]
      enabled = true
      org_role = Admin
    '';
  };
}
