#!/usr/bin/env zsh

setopt noglobalrcs
export LANG="en_US.UTF-8"
export LC_ALL="$LANG"

export USER_FULLNAME="Christopher Lord"
export USER_EMAIL=christopherlord@gmail.com
export USER_URL=http://christopher.lord.ac
export EDITOR="vim"
export REPLYTO=$USER_EMAIL

prepend_path() {
   [ -d $1/sbin ] && path=($1/sbin $path)
   [ -d $1/shims ] && path=($1/shims $path)
   [ -d $1/bin ] && path=($1/bin $path)
   [ -d $1/scripts ] && path=($1/scripts $path)
   [ -d $1/share/man ] && manpath=($1/share/man $manpath)
}

append_path() {
   [ -d $1/sbin ] && path+=($1/sbin)
   [ -d $1/bin ] && path+=($1/bin)
   [ -d $1/shims ] && path+=($1/shims)
   [ -d $1/scripts ] && path+=($1/scripts)
   [ -d $1/share/man ] && manpath+=($1/share/man)
}


prepend_path ''
prepend_path /usr
prepend_path /usr/linux
prepend_path /opt/local
prepend_path /usr/local
prepend_path /opt/gcc-5.1.0  # prepend_path /opt/gcc-4.8.1
prepend_path $HOME/.cabal
prepend_path $HOME/Library/Haskell
prepend_path $HOME/dotfiles
prepend_path $HOME/.rbenv
prepend_path $HOME/.local
prepend_path $HOME/.local/`uname -s`
prepend_path $HOME/.local/`uname -s`/gems

if [[ $OSTYPE == darwin* ]]; then
   path=($path /usr/texbin)
fi

# look in ./.local, too. This lets subprojects override things
path=(./bin ./.local/bin ./.local/scripts $path)
manpath=(./.local/share/man $manpath)

typeset -U path
typeset -U manpath

fpath=(~/.zsh/functions $fpath)
typeset -U fpath

# Some ruby goodness
export GEM_HOME=$HOME/.local/`uname -s`/gems
export RUBYLIB=$RUBYLIB:$HOME/dotfiles/scripts:$HOME/.local/scripts/ruby
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules

# Cap some silly things I don't need
ulimit -c 0

