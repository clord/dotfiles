#!/usr/bin/env zsh
IFS=$'\n\t'

# Invoke startup scripts for every interactive session

for conf (~/.zsh/conf.d/*(N.)) source $conf
for func (~/.zsh/func.d/*(N.)) autoload -U ${func:t}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
