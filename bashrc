function sourceIfExists {
    if [ -f $@ ]; then
        source $@
    fi
}

sourceIfExists ~/.local/bin/bashmarks.sh
sourceIfExists ~/.local/bin/dynamicaliases.sh
sourceIfExists ~/.bash_work
sourceIfExists ~/.bash_local

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Github API token
export HOMEBREW_GITHUB_API_TOKEN=14b7a2ebc76c470ae698a4d786664cc2c48900a4

# super cd ..
# Add an additional . for each directory
cd() { if [[ "$1" =~ ^\.\.+$ ]];then local a dir;a=${#1};while [ $a -ne 1 ];do dir=${dir}"../";((a--));done;builtin cd $dir;else builtin cd "$@";fi ;}

# fix tmux term
if [ "$TERM" == "screen" ]; then
  export TERM=tmux-256color
fi
