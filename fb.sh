#!/usr/bin/env bash

export FBANDROID_DIR=/Users/jearil/fbsource/fbandroid
alias quicklog_update=/Users/jearil/fbsource/fbandroid/scripts/quicklog/quicklog_update.sh
alias qlu=quicklog_update

# added by setup_fb4a.sh
export ANDROID_SDK=/opt/android_sdk
export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH=${JAVA_HOME}/bin:${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools

# BEGIN: Block added by chef, to set environment strings
# Please see https://fburl.com/AndroidProvisioning if you do not use bash
# or if you would rather this bit of code 'live' somewhere else
. ~/.fbchef/environment
# END: Block added by chef
eval $(/usr/libexec/path_helper -s)


export PATH=${JAVA_HOME}/bin:~/bin:/usr/local/bin:${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools

export PATH="$HOME/.cargo/bin:$PATH"
