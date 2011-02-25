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

path=(
     {/usr/linux,$HOME/{.local{,/`uname -s`},.cabal},/usr/local}/{,s}bin
     $path /C++/montana/bin
     {/usr,}/{,s}bin
     )

manpath=(
     {/usr/linux,$HOME/.local{,/`uname -s`},/usr/local}/share/man
     $manpath
     )

fpath=(
     ~/.zsh/{func.d,comp.d}
     $fpath
     )

# Some ruby goodness
export GEM_HOME=$HOME/.local/`uname -s`/gems
export LOAD_PATH=$LOAD_PATH:$HOME/dotfiles/scripts

# Now add some platform-specific customizations

if [[ $OSTYPE == darwin* ]]; then
	# Add homebrew's ruby to the path
	path=(/usr/local/Cellar/ruby/1.9.2-p0/bin $path)
fi

# Now for ugly hacks from outside influences:

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
