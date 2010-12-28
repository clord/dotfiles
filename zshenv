#!/usr/bin/env zsh

setopt noglobalrcs
export LANG=en_US.utf-8
export LC_ALL=$LANG

export USER_FULLNAME="Christopher Lord"
export USER_EMAIL=christopherlord@gmail.com
export USER_URL=http://christopher.lord.ac
export EDITOR="vim"
export REPLYTO=$USER_EMAIL

path=(
     {$HOME/.local,/usr/local}/{,s}bin
     {/usr,}/{,s}bin
     $path
     )
manpath=(
     {$HOME/.local,/usr/local}/share/man
     $manpath
     )
fpath=(
     ~/.zsh/{func.d,comp.d}
     $fpath
     )
