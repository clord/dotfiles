#!/usr/bin/env zsh

setopt noglobalrcs
export LANG="en_US.utf-8"
export LC_ALL="$LANG"

export USER_FULLNAME="Christopher Lord"
export USER_EMAIL=christopherlord@gmail.com
export USER_URL=http://christopher.lord.ac
export EDITOR="vim"
export REPLYTO=$USER_EMAIL

path=(
     {$HOME/{.local{,/`uname -s`},.cabal},/usr/local,/usr/linux}/{,s}bin
     {/usr,}/{,s}bin
     $path
     )

manpath=(
     {$HOME/.local{,/`uname -s`},/usr/local,/usr/linux}/share/man
     $manpath
     )

fpath=(
     ~/.zsh/{func.d,comp.d}
     $fpath
     )

# Now add some platform-specific customizations

if [[ $OSTYPE == darwin* ]]; then
	# Add homebrew's ruby to the path
	path=(/usr/local/Cellar/ruby/1.9.2-p0/bin $path)
fi

# Now for ugly hacks from outside influences:

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
