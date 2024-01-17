{ config, pkgs, ... }: {

  programs.fish = {
    enable = true;
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
      #dotdot = {
      #  regex = "^\\.\\.+$";
      #  function = "multicd";
      #};
    };
    shellAbbrs = {
      vim = "nvim";
      v = "nvim";
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
        argumentNames = [ "r" ];
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