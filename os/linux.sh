# Linux-only shell settings.
_dot_notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1"
    else
        printf '\a%s\n' "$1"
    fi
}
