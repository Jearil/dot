function sourceIfExists {
    if [ -f $@ ]; then
        source $@
    fi
}

sourceIfExists ~/.local/bin/bashmarks.sh
sourceIfExists ~/.local/bin/dynamicaliases.sh
sourceIfExists ~/.bash_work.bash
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

# make hg_ps1
hg_ps1() {
  local INFO
  INFO=$(hg book -ql . 2> /dev/null)
  if [ $? -eq 0 ]; then
    echo -e "[$INFO]"
  fi
}

# Prompt
export PS1="\n \[\033[0;34m\]╭─\[\033[0;31m\]\[\033[0;37m\]\[\033[41m\] $OS_ICON \u \[\033[0m\]\[\033[0;31m\]\[\033[44m\]\[\033[0;34m\]\[\033[44m\]\[\033[0;30m\]\[\033[44m\] \w \[\033[0m\]\[\033[0;34m\]\$(__git_ps1)\$(hg_ps1) \n \[\033[0;34m\]╰ \[\033[1;36m\]\$ \[\033[0m\]"
# export PS1="\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\[\033[1;37m\]\$(__git_ps1)\$(hg_ps1)\n\342\224\224\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"

# Man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
