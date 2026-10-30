# Environment shared by bash and zsh. Expects DOT_DIR from the ~/.zshrc or ~/.bashrc stub.
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH"
export EDITOR=vim
GPG_TTY=$(tty 2>/dev/null) && export GPG_TTY

# Android SDK, on machines that have it
if [ -d /mnt/Games/Android/SDK ]; then
    export ANDROID_HOME=/mnt/Games/Android/SDK
    export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator"
fi

# OS and per-host layers
DOT_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
DOT_HOST=$(hostname -s | tr '[:upper:]' '[:lower:]')
[ -f "$DOT_DIR/os/$DOT_OS.sh" ] && . "$DOT_DIR/os/$DOT_OS.sh"
[ -f "$DOT_DIR/hosts/$DOT_HOST/shell.sh" ] && . "$DOT_DIR/hosts/$DOT_HOST/shell.sh"
