{pkgs, ...}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "a34b0c2809f665e854d6813dd4b052c1b32a32b4";
          sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
      }
    ];
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block
      set -g theme_display_vi yes
      set -g theme_title_display_user ssh
      set -g theme_title_display_hostname ssh
      set -g theme_display_nix no
      set -g default_user clord
    '';
    shellAliases = {
    };
    shellAbbrs = {
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
      gd = "git diff --patience -w";
      lll = "eza -bghHliS";
    };
    functions = {
      t = "cd (mktemp -d /tmp/$1.XXXX)";
      mcd = "mkdir -p $argv; and cd $argv";
      prepend_path = {
        argumentNames = ["r"];
        body = ''
          if test -d $r
              test -d $r/sbin ; and set PATH $r/sbin $PATH
              test -d $r/bin ; and set PATH $r/bin $PATH
              test -d $r/scripts ; and set PATH $r/scripts $PATH
              test -d $r/share/man ; and set MANPATH $r/share/man $MANPATH
          end
        '';
      };
    };
  };
}
