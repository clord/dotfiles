_: {
  programs = {
    nushell = {
      enable = false;
      extraConfig = ''
        $env.config = {
          show_banner: false,
          completions: {
            case_sensitive: false # case-sensitive completions
            quick: true    # set to false to prevent auto-selecting completions
            partial: true    # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
              # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100
            }
          }
        }
        $env.PATH = ($env.PATH | split row (char esep) | prepend node_modules/.bin | append /usr/bin/env)
      '';
      shellAliases = {
        v = "neovide";
        vim = "nvim";
        c = "clear";
        g = "git";
        s = "git status -sb";
        ga = "git add -A";
        gs = "git switch";
        "gs!" = "git switch --create";
        gc = "git commit --verbose";
        gp = "git push";
        gu = "git pull";
        gd = "git diff -w";
        lll = "eza -bghHliS";
      };
    };

    starship = {
      enable = false;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
}
