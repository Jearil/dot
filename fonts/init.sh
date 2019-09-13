# OSX-only stuff. Abort if not OSX.
if [[ ! `uname` == 'Darwin' ]]; then
    exit
fi

DIRECTORY=$(cd `dirname $0` && pwd)

# Copy fonts
cp -f $DIRECTORY/*.ttf $HOME/Library/Fonts 
