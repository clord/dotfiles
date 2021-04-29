set fish_greeting

set -x EDITOR vim
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

set -x USER_FULLNAME "Christopher Lord"
set -x USER_EMAIL christopherlord@gmail.com
set -x USER_URL http://christopher.lord.ac
set -x REPLYTO $USER_EMAIL

set -x SPACEFISH_NODE_SHOW false

# Setting fd as the default source for fzf
set -x FZF_DEFAULT_COMMAND fd --type f --hidden  --follow --exclude .git --exclude node_modules
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

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

## LLVM
# prepend_path /usr/local/opt/llvm
# set -gx LDFLAGS "-L/usr/local/opt/llvm/lib" $LDFLAGS
# set -gx CPPFLAGS "-I/usr/local/opt/llvm/include" $CPPFLAGS
# F for respects to apple
# set -gx LDFLAGS (xcrun --show-sdk-path)/usr/lib $LDFLAGS
# set -gx CPPFLAGS (xcrun --show-sdk-path)/usr/include $CPPFLAGS
# set -gx CPATH (xcrun --show-sdk-path)/usr/include $CPATH
# set -gx C_INCLUDE_PATH (xcrun --show-sdk-path)/usr/include $C_INCLUDE_PATH
# set -gx LIBRARY_PATH (xcrun --show-sdk-path)/usr/lib $LIBRARY_PATH

set -gx GOPATH $HOME/.go

prepend_path /opt
prepend_path /usr/local
prepend_path /opt/local
prepend_path $HOME/.cabal
prepend_path $HOME/.cargo
prepend_path $GOPATH
# prepend_path ~/.local/(uname -s)
# prepend_path ~/.local/(uname -s)/gems

prepend_path /usr/local/opt/gpg

set PATH node_modules/.bin $PATH

function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# How to represent as abbr?
function mcd   ; mkdir -p $argv; and cd $1; end
# function cr    ; cd `git rev-parse --show-toplevel`; end


if command -s vimr > /dev/null
  abbr -a vim vimr
  abbr -a v vimr

else
  if command -s nvim > /dev/null
    abbr -a vim nvim
    abbr -a v nvim
  end
end

abbr -a c clear
abbr -a g git
abbr -a ga git add -A
abbr -a gs git switch
abbr -a s git status
abbr -a gc git commit
abbr -a gp git push
abbr -a gu git pull
abbr -a gb git branch
abbr -a gd git diff --patience -w
abbr -a l exa
abbr -a ls exa
abbr -a ll exa -l
abbr -a lll exa -bghHliS

function t
    cd (mktemp -d /tmp/$1.XXXX)
end

source ~/.local/local_env.fish


# Enable vi mode
fish_vi_key_bindings
source ~/.asdf/asdf.fish
set -g fish_user_paths "/usr/local/opt/node@10/bin" $fish_user_paths

if test -e '/Users/clord/.nix-profile/etc/profile.d/nix.sh'
  bass source '/Users/clord/.nix-profile/etc/profile.d/nix.sh'
end



eval (direnv hook fish)

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/clord/google-cloud-sdk/path.fish.inc' ]; . '/Users/clord/google-cloud-sdk/path.fish.inc'; end

status --is-interactive; and source (rbenv init -|psub)

