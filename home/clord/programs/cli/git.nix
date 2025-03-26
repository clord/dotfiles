{pkgs, ...}: let
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
    if pkgs.system == "aarch64-darwin"
    then {
      program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    }
    else {};
in {
  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "ssh";
      http_unix_socket = "";
      browser = "";
      aliases = {
        co = "pr checkout";
      };
      editor = "nvim";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [
    	"*~" 
	"*.swp"
        ".DS_Store"
        ".idea"
    ];
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTOl4xwPOT82EmW5bEBpWyi5Iy9ZEYWPToJEQjIagyO";
      signByDefault = true;
    };
    userName = "Christopher Lord";
    userEmail = "christopher@pliosoft.com";
    difftastic.enable = true;
    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:grafana/**";
        path = builtins.toFile "git-grafana.inc" ''
          [user]
           name = Christopher Lord
           email = christopher.lord@grafana.com
        '';
      }
    ];

    aliases = {
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
      unstage = "reset HEAD --";
      staged = "diff --cached";
      unstaged = "diff";
      last = "log -1 HEAD";
      s = "status -s";
      d = "diff -w --minimal --word-diff=color --color-words --abbrev";
      dt = "difftool";
      c = "commit -am";
      amend = "commit --amend";
      # conflicts = "diff --name-only --diff-filter=U --relative";
      conflict = "diff --check";
      a = "add";
      ai = "add --interactive";
      tree = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      recent = "for-each-ref --sort=-committerdate refs/heads --format='%(refname:short)|%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' --color=always --count=20";
    };

    extraConfig = {
      github.user = "clord";
      init.defaultBranch = "main";
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      branch.autoSetupMerge = "true";
      apply.whitespace = "fix,trailing-space,space-before-tab,cr-at-eol";
      branch.sort = "-commiterdate";
      interactive.diffFilter = "difft";
      log = {
        decorate = "short";
        date = "local";
      };
      format.numbered = "auto";
      fetch.prune = "true";
      commit = {
        template = "${gitMessage}";
        verbose = true;
      };
      rerere = {
        enabled = "true";
        autoupdate = "true";
      };
      gpg = {format = "ssh";};
      tag = {sort = "version:refname";};
      merge = {
        stat = "true";
        conflictStyle = "zdiff3";
        # tool = "gitmergetool";
        tool = "${pkgs.meld}/bin/meld";
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
        algorithm = "histogram";
        compactionHeuristic = "true";
        colorMoved = "zebra";
      };
      "credential \"https://github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";

      "gpg \"ssh\"" = macInclude;
    };
  };

  home.packages = with pkgs; [difftastic gitAndTools.transcrypt gh git-lfs];
}
