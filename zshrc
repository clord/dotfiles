#!/usr/bin/env zsh

# Invoke startup scripts for every interactive session
for conf (~/.zsh/configuration/*(N.)) source $conf
for func (~/.zsh/functions/*(N.)) autoload -U ${func:t}

