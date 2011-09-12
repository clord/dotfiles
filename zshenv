#!/usr/bin/env zsh

setopt noglobalrcs
if [[ $OSTYPE != aix* ]]; then
   export LANG="en_US.utf-8"
   export LC_ALL="$LANG"
fi

export USER_FULLNAME="Christopher Lord"
export USER_EMAIL=christopherlord@gmail.com
export USER_URL=http://christopher.lord.ac
export EDITOR="vim"
export REPLYTO=$USER_EMAIL

prepend_path() {
   [ -d $1/sbin ] && path=($1/sbin $path)
   [ -d $1/bin ] && path=($1/bin $path)
   [ -d $1/scripts ] && path=($1/scripts $path)
   [ -d $1/share/man ] && manpath=($1/share/man $manpath)
}

append_path() {
   [ -d $1/sbin ] && path+=($1/sbin)
   [ -d $1/bin ] && path+=($1/bin)
   [ -d $1/scripts ] && path+=($1/scripts)
   [ -d $1/share/man ] && manpath+=($1/share/man)
}

prepend_path /usr
prepend_path /usr/linux
prepend_path /usr/local
prepend_path /C++/montana
prepend_path /usr/local/Cellar/python/2.7.2
prepend_path $HOME/.cabal
prepend_path $HOME/dotfiles
prepend_path $HOME/.local
prepend_path $HOME/.local/`uname -s`
prepend_path $HOME/.local/`uname -s`/gems

if [[ $OSTYPE == darwin* ]]; then
   # homebrew rocks, worth sullying my script with this hack
   prepend_path /usr/local/Cellar/ruby/1.9.2-p180

   path=($path /usr/local/texlive/2011/bin/x86_64-darwin)
fi


# look in ./.local, too. This lets subprojects override things
path=(./.local/bin ./.local/scripts $path)
manpath=(./.local/share/man $manpath)


typeset -U path
typeset -U manpath


fpath=(~/.zsh/{func.d,comp.d} $fpath)
typeset -U fpath

# Some ruby goodness
export GEM_HOME=$HOME/.local/`uname -s`/gems
export RUBYLIB=$RUBYLIB:$HOME/dotfiles/scripts:$HOME/.local/scripts/ruby


# Now for ugly hacks from outside influences:

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
