#!/usr/bin/env bash

set -e

if ! command -v brew > /dev/null; then
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$brew" ] && eval "$("$brew" shellenv)"
  done
fi

if ! command -v brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$brew" ] && eval "$("$brew" shellenv)"
  done
fi

brew update
brew bundle --file "$(dirname "$0")/packages/Brewfile"
