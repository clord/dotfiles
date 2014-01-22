#!/usr/bin/env zsh
IFS=$'\n\t'

# For mac, present environment variables to GUI applications. 
# remove the plist file and it will be regenerated on login.

if [[ $OSTYPE == darwin* ]]; then
    env=$HOME/.MacOSX/environment
    if [[ ! -f $env.plist ]]; then
        for var in PATH MANPATH LANG LC_ALL; do
            defaults write $env $var "${(P)var}"
        done
    fi
fi

