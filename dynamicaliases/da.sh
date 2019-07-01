#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)

# Install dynamic aliases if it doesn't exist
if [ ! -f ~/.local/bin/dynamicaliases.sh ]; then
  echo -e "\e[93mInstalling Dynamic Aliases\e[0m"
  cd $DIRECTORY/src
  make install
fi

source ~/.local/bin/dynamicaliases.sh
echo -e "\e[1;32mDynamic Aliases Done\e[0m"
