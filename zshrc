#!/usr/bin/env zsh

# Invoke startup scripts for every interactive session

for conf (~/.zsh/conf.d/*(N.)) source $conf
for func (~/.zsh/func.d/*(N.)) autoload -U ${func:t}
