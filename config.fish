set fish_greeting

set -x EDITOR vimr
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

set -x USER_FULLNAME "Christopher Lord"
set -x USER_EMAIL christopherlord@gmail.com
set -x USER_URL http://christopher.lord.ac
set -x REPLYTO $USER_EMAIL

set -x GEM_HOME $HOME/.local/(uname -s)/gems
set -x RUBYLIB $RUBYLIB:$HOME/dotfiles/scripts:$HOME/.local/scripts/ruby
set -x NODE_PATH $NODE_PATH:/usr/local/lib/node_modules

set -x SPACEFISH_NODE_SHOW false

ulimit -c 0

function prepend_path --argument-names r
   if test -d $r
      test -d $r/sbin ; and set PATH $r/sbin $PATH
      test -d $r/bin ; and set PATH $r/bin $PATH
      test -d $r/scripts ; and set PATH $r/scripts $PATH
      test -d $r/share/man ; and set MANPATH $r/share/man $MANPATH
   end
end

set -x PLAN9 /usr/local/plan9

prepend_path /
prepend_path /usr
# prepend_path $HOME/.nix-profile
# prepend_path $PLAN9
prepend_path /opt
prepend_path /usr/local
prepend_path /opt/local
prepend_path $HOME/.cabal
prepend_path $HOME/.cargo
prepend_path ~/.local/(uname -s)
prepend_path ~/.local/(uname -s)/gems

set PATH node_modules/.bin $PATH

function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# How to represent as abbr?
function mcd   ; mkdir -p $argv; and cd $1; end
# function cr    ; cd `git rev-parse --show-toplevel`; end

abbr -a g git
abbr -a vim vimr
abbr -a v vimr

abbr -a c clear
abbr -a ga git add -A
abbr -a gs git switch
abbr -a s git status
abbr -a gc git commit
abbr -a gp git push
abbr -a gb git branch
abbr -a gd git diff --patience -w
abbr -a l tree --dirsfirst -aFCNL 1
abbr -a ll tree --dirsfirst -ChFupDaLg 1

function t
    cd (mktemp -d /tmp/$1.XXXX)
end


# Enable vi mode
fish_vi_key_bindings
source ~/.asdf/asdf.fish
set -g fish_user_paths "/usr/local/opt/node@10/bin" $fish_user_paths
