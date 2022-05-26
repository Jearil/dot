function sourceIfExists {
    if [ -f $@ ]; then
        source $@
    fi
}

sourceIfExists ~/.countdown
sourceIfExists ~/.warn
sourceIfExists ~/.bash_ios
sourceIfExists ~/.utils.sh

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

hg_ps1() {
  hg prompt " ({bookmark})" 2> /dev/null
}

# export PS1="\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\[\033[1;37m\]\$(__git_ps1)\n\342\224\224\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(gls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"
# Old Tested
# export PS1="\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\[\033[1;37m\]\$(__git_ps1)\$(hg_ps1)\n\342\224\224\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"

# Fancy
OS_ICON=O
export EDITOR=vim
export GPG_TTY=$(tty)

# get git-prompt going
sourceIfExists ~/.git-prompt.sh
sourceIfExists ~/.git-completion.bash

# source ~/.preexec.bash

# Add the android sdk tools
export PATH=${PATH}:~/.local/bin

sourceIfExists "${HOME}/.iterm2_shell_integration.bash"
