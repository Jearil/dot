function sourceIfExists {
    if [ -f $@ ]; then
        source $@
    fi
}

sourceIfExists /opt/facebook/share/scm-prompt

sourceIfExists ~/.countdown
sourceIfExists ~/.warn
sourceIfExists ~/.bash_ios
sourceIfExists ~/.work
sourceIfExists ~/.utils.sh

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# export PS1="\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\[\033[1;37m\]\$(__git_ps1)\n\342\224\224\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(gls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"
export PS1="\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\[\033[1;37m\]\$(__git_ps1)\$(_dotfiles_scm_info)\n\342\224\224\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"
export EDITOR=vim
export GPG_TTY=$(tty)

# get git-prompt going
sourceIfExists ~/.git-prompt.sh
sourceIfExists ~/.git-completion.bash

# source ~/.preexec.bash

# Add the android sdk tools
export PATH=${PATH}:/opt/android_sdk/tools/bin
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

sourceIfExists "${HOME}/.iterm2_shell_integration.bash"

# file descriptor limits should be increased
ulimit -n 200000

function mountAndroid {
    hdiutil attach ~/Android.sparseimage -mountpoint /Volumes/android;
}

function unmountAndroid {
    hdiutil detatch /Volumes/android;
}

##
# Your previous /Users/jearil/.bash_profile file was backed up as /Users/jearil/.bash_profile.macports-saved_2016-10-27_at_15:38:41
##

# MacPorts Installer addition on 2016-10-27_at_15:38:41: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

#CHEF.NO.SOURCE
