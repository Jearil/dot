#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)

cp -R $DIRECTORY/bookmarks ~/.oh-my-zsh/custom/plugins/
mkdir -p ~/.config/zsh
