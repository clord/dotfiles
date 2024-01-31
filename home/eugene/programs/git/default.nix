{
  config,
  pkgs,
  ...
}: let
  gitConfig = {
    core = {editor = "nvim";};

    user = {
      email = "eugene@lord.ac";
      name = "Eugene Lord";
    };
    init.defaultBranch = "main";
    merge = {conflictStyle = "diff3";};
    pull.rebase = true;
    url = {
      "https://github.com/".insteadOf = "gh:";
      "ssh://git@github.com".pushInsteadOf = "gh:";
      "https://gitlab.com/".insteadOf = "gl:";
      "ssh://git@gitlab.com".pushInsteadOf = "gl:";
    };
  };

  rg = "${pkgs.ripgrep}/bin/rg";
in {
  programs.git = {
    enable = true;
    aliases = {
      amend = "commit --amend";
      loc = ''!f(){ git ls-files | ${rg} "\.''${1}" | xargs wc -l; };f''; # lines of code
      br = "branch";
      co = "checkout";
      st = "status";
      ls = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'';
      ll = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
      com = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      a = "add -A";
    };
    extraConfig = gitConfig;
  };
}
