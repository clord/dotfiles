set fish_greeting
set -x EDITOR nvim
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

set -x USER_FULLNAME "Christopher Lord"
set -x USER_EMAIL christopherlord@gmail.com
set -x USER_URL http://christopher.lord.ac
set -x REPLYTO $USER_EMAIL

set -x GEM_HOME $HOME/.local/(uname -s)/gems
set -x RUBYLIB $RUBYLIB:$HOME/dotfiles/scripts:$HOME/.local/scripts/ruby
set -x NODE_PATH $NODE_PATH:/usr/local/lib/node_modules

ulimit -c 0

function prepend_path --argument-names r
   if test -d $r
      test -d $r/sbin ; and set PATH $r/sbin $PATH
      test -d $r/bin ; and set PATH $r/bin $PATH
      test -d $r/scripts ; and set PATH $r/scripts $PATH
      test -d $r/share/man ; and set MANPATH $r/share/man $MANPATH
   end
end

prepend_path /
prepend_path /usr
prepend_path /opt
prepend_path /usr/local
prepend_path /opt/local
prepend_path $HOME/.cabal
prepend_path $HOME/.cargo

function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end
function l     ; tree --dirsfirst -aFCNL 1 $argv ; end
function ll    ; tree --dirsfirst -ChFupDaLg 1 $argv ; end
function mcd   ; mkdir -p $argv; and cd $1; end



function a        ; command ag --ignore=.git --ignore=log --ignore=tags --ignore=tmp --ignore=vendor --ignore=spec/vcr $argv ; end
function g        ; git $argv ; end
function ga       ; git add -A $argv; end
function gc       ; git commit $argv; end
function gd       ; git diff --patience -w $argv; end
function gs       ; git status -s $argv; end


# Completions
function make_completion --argument-names alias command
    echo "
    function __alias_completion_$alias
        set -l cmd (commandline -o)
        set -e cmd[1]
        complete -C\"$command \$cmd\"
    end
    " | .
    complete -c $alias -a "(__alias_completion_$alias)"
end

make_completion g 'git'
make_completion ga 'git-add'
make_completion gd 'git-diff'
make_completion gs 'git-status'
