#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)
mkdir -p ~/.vim/plugin
cp -r $DIRECTORY/dot/* ~/.vim/
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
echo "Running Vim Vundle PluginInstall. You may need to hit enter a few times"
vim +PluginInstall +qall
