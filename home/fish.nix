{ config, pkgs, ... }: {

  programs.fish = {
    enable = true;
    shellAbbrs = {
      gco = "git checkout";
        c = "clear";
        g = "git";
        v = "nvim";
        ga = "git add";
        gs = "git switch";
        s = "git status";
        gc = "git commit";
        gp = "git push";
        gu = "git pull";
        gd = "git diff --patience -w";
        l = "exa";
        ls = "exa";
        ll = "exa -l";
        lll = "exa -bghHliS";
        #dotdot = {
        #  regex = "^\\.\\.+$";
        #  function = "multicd";
        #};

  };
      functions = {
        t = ''cd (mktemp -d /tmp/$1.XXXX)'';
        mcd = ''mkdir -p $argv; and cd $argv'';
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
