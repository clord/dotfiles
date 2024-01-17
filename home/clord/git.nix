{ pkgs, ... }:
let
  grafanaInclude = {
    user = {
      name = "Christopher Lord";
      email = "christopher.lord@grafana.com";
    };
  };

  gitMessage = pkgs.writeText "gitmessage" ''
    ### Title: Summary, imperative, start upper case, don't end with a period
    # No more than 50 chars. #### 50 chars is here: #

    # Remember blank line between title and body.

    ### Body: Explain *what* and *why* (not *how*). Include issue reference 
    # Wrap at 72 chars. ################################## which is here: #


    # At the end: Include Co-authored-by for all contributors. 
    # Include at least one empty line before it. Format: 
    # Co-authored-by: Name <user@users.noreply.github.com>
  '';

  macInclude =
    if pkgs.system == "aarch64-darwin" then {
      program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    } else
      { };
in
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      aliases = { co = "pr checkout"; };
      editor = "nvim";
    };
  };

  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    #signing = {
    #  key =
    #    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTOl4xwPOT82EmW5bEBpWyi5Iy9ZEYWPToJEQjIagyO";
    #  signByDefault = true;
    #};
    userEmail = "christopher@pliosoft.com";
    userName = "Christopher Lord";

    includes = [{
      condition = "gitdir:~/src/grafana/*";
      contents = grafanaInclude;
    }];

    extraConfig = {
      github.user = "clord";
      init.defaultBranch = "main";
      branch.autoSetupMerge = "true";
      apply.whitespace = "fix,trailing-space,space-before-tab,cr-at-eol";
      interactive.diffFilter = "difft";
      log.decorate = "short";
      format.numbered = "auto";
      fetch.prune = "true";
      commit = {
        # template = gitMessage;
        # gpgsign = "true";
      };
      rerere = {
        enabled = "true";
        autoupdate = "true";
      };
      # gpg = { format = "ssh"; };
      merge = {
        stat = "true";
        conflictStyle = "diff3";
        tool = "gitmergetool";
      };
      user = {
        name = "Christopher Lord";
        email = "christopher@pliosoft.com";
      };
      push = {
        default = "current";
        autoSetupRemote = "true";
        followTags = "true";
      };
      diff = {
        algorithm = "patience";
        compactionHeuristic = "true";
        colorMoved = "zebra";
        external = "difft";
      };
      "credential \"https://github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";

      # "gpg \"ssh\"" = macInclude;
    };

    aliases = {
      lg =
        "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
      unstage = "reset HEAD --";
      staged = "diff --cached";
      unstaged = "diff";
      last = "log -1 HEAD";
      s = "status -s";
      d = "diff -w --minimal --word-diff=color --color-words --abbrev --patience";
      dt = "difftool";
      c = "commit -am";
      amend = "commit --amend";
      a = "add";
      ai = "add --interactive";
      tree = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      recent = ''branch --sort=-committerdate --format="%(committerdate:relative)%09%(refname:short)"'';
    };

    # delta = {
    #  enable = true;
    #  options = {
    #    features = "decorations";
    #    whitespace-error-style = "22 reverse";
    #    decorations = {
    #      commit-decoration-style = "bold yellow box ul";
    #      file-style = "bold yellow ul";
    #      file-decoration-style = "none";
    #    };
    #  };
    #};
  };

  home.packages = with pkgs; [ difftastic gitAndTools.transcrypt gh ];
}

