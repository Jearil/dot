#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)
mkdir -p ~/.vim/plugin
cp -r $DIRECTORY/dot/* ~/.vim/
if [ ! -d ~/.vim/bundle/Vundle.vim]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
if [ ! -d ~/.vim/bundle/vim-colorschemes]; then
    git clone https://github.com/flazz/vim-colorschemes.git ~/.vim/bundle/vim-colorschemes
fi
