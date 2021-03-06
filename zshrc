#!/usr/bin/env zsh

# Invoke startup scripts for every interactive session
for conf (~/.zsh/configuration/*(N.)) source $conf
for func (~/.zsh/functions/*(N.)) autoload -U ${func:t}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
