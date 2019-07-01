#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)

# Install bashmarks if it doesn't exist
if [ ! -f ~/.local/bin/bashmarks.sh ]; then
  echo "Installing Bashmarks"
  cd $DIRECTORY/bashmarks
  make install
fi

source ~/.local/bin/bashmarks.sh
cd ~
s h
s home
mkdir -p ~/Projects
cd ~/Projects
s p
echo -e "\e[1;32mBashmarks Done\e[0m"
