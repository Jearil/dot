# macOS-only shell settings.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$_brew" ]; then
        eval "$("$_brew" shellenv)"
        break
    fi
done
unset _brew

export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

_dot_notify() {
    osascript -e "display notification \"$1\" with title \"Terminal\""
}
