#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)

if [[ `uname` == 'Darwin' ]]; then
    cp -f $DIRECTORY/*.ttf $HOME/Library/Fonts
else
    mkdir -p $HOME/.local/share/fonts
    cp -f $DIRECTORY/*.ttf $HOME/.local/share/fonts
    if command -v fc-cache > /dev/null; then
        fc-cache -f $HOME/.local/share/fonts
    fi
fi
