# OSX-only stuff. Abort if not OSX.
if [[ ! `uname` == 'Darwin' ]]; then
  return
fi

DIRECTORY=$(cd `dirname $0` && pwd)

# Copy fonts
e_header "Copying fonts (${#setdiffC[@]})"
cp -f $DIRECTORY/fonts/*.ttf $HOME/Library/Fonts 
