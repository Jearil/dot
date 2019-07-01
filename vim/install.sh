#!/usr/local/env bash

DIRECTORY=$(cd `dirname $0` && pwd)
mkdir -p ~/.vim/plugin
cp -r $DIRECTORY/dot/* ~/.vim/

